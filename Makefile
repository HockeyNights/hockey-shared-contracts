IMAGE  ?= hockey-protoc:dev
MODULE := github.com/HockeyNights/hockey-shared-contracts

DOCKER_PROTOC = docker run --rm \
	-u $$(id -u):$$(id -g) \
	-v "$(CURDIR)":/src -w /src \
	$(IMAGE)

APIS := $(shell find . -mindepth 3 -name '*.proto' -not -path './.protodeps/*' | cut -d/ -f2 | sort -u)
INCLUDES = -I . -I .protodeps

SELECTABLE := generate check clean

ifneq (,$(filter $(SELECTABLE),$(MAKECMDGOALS)))
SELECTED := $(filter-out $(SELECTABLE),$(MAKECMDGOALS))
endif

ifeq (,$(SELECTED))
TARGET_APIS := $(APIS)
else
UNKNOWN := $(filter-out $(APIS),$(SELECTED))
ifneq (,$(UNKNOWN))
$(error нет такого контракта: $(UNKNOWN). Доступны: $(APIS))
endif
TARGET_APIS := $(SELECTED)

$(foreach api,$(SELECTED),$(eval .PHONY: $(api))$(eval $(api): ; @:))
endif

.PHONY: image
image:
	@docker build -q -t $(IMAGE) . >/dev/null


GRPC_GATEWAY_REF   ?= v2.30.0
GOOGLEAPIS_REF     ?= 9415ba048aa587b1b2df2b96fc00aa009c831597
PROTOVALIDATE_REF  ?= v1.2.0

PROTODEPS_FILES = \
	.protodeps/google/api/annotations.proto \
	.protodeps/google/api/http.proto \
	.protodeps/protoc-gen-openapiv2/options/annotations.proto \
	.protodeps/protoc-gen-openapiv2/options/openapiv2.proto \
	.protodeps/buf/validate/validate.proto

.PHONY: protodeps
protodeps: $(PROTODEPS_FILES)

.protodeps/google/api/%.proto:
	@mkdir -p $(dir $@)
	@curl -fsSL -o $@ \
		https://raw.githubusercontent.com/googleapis/googleapis/$(GOOGLEAPIS_REF)/google/api/$*.proto

.protodeps/protoc-gen-openapiv2/options/%.proto:
	@mkdir -p $(dir $@)
	@curl -fsSL -o $@ \
		https://raw.githubusercontent.com/grpc-ecosystem/grpc-gateway/$(GRPC_GATEWAY_REF)/protoc-gen-openapiv2/options/$*.proto

.protodeps/buf/validate/validate.proto:
	@mkdir -p $(dir $@)
	@curl -fsSL -o $@ \
		https://raw.githubusercontent.com/bufbuild/protovalidate/$(PROTOVALIDATE_REF)/proto/protovalidate/buf/validate/validate.proto

.PHONY: protodeps-clean
protodeps-clean:
	@rm -rf .protodeps

.PHONY: generate
generate: image protodeps
	@for api in $(TARGET_APIS); do \
		echo "  $$api"; \
		rm -rf $$api/gen $$api/swagger; \
		$(DOCKER_PROTOC) protoc $(INCLUDES) \
			--go_out=. --go_opt=module=$(MODULE) \
			--go-grpc_out=. --go-grpc_opt=module=$(MODULE) \
			--grpc-gateway_out=. --grpc-gateway_opt=module=$(MODULE) \
			$$api/v*/*.proto || exit 1; \
		$(DOCKER_PROTOC) sh -c "mkdir -p $$api/swagger \
			&& protoc $(INCLUDES) --openapiv2_out=$$api/swagger \
				--openapiv2_opt=logtostderr=true,allow_merge=true,merge_file_name=$$api \
				$$api/v*/*.proto" || exit 1; \
	done
	@echo "готово: $(TARGET_APIS)"

.PHONY: check
check: image protodeps
	@for api in $(TARGET_APIS); do \
		$(DOCKER_PROTOC) protoc $(INCLUDES) -o /dev/null $$api/v*/*.proto || exit 1; \
	done
	@echo "контракты валидны: $(TARGET_APIS)"

.PHONY: clean
clean:
	@test -z "$(TARGET_APIS)" || rm -rf \
		$(foreach api,$(TARGET_APIS),$(api)/gen $(api)/swagger)

.PHONY: tidy
tidy:
	go mod tidy
