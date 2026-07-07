ROOT_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/../)
CODEGEN_IMAGE := hockeynights-contracts-codegen

.PHONY: generate clean codegen-image

codegen-image:
	docker build \
		-f $(ROOT_DIR)/tools/codegen/Dockerfile \
		-t $(CODEGEN_IMAGE) \
		$(ROOT_DIR)

generate: codegen-image
	@echo "Prepare mail contracts generation"
	rm -rf langs
	mkdir -p langs/go langs/openapi
	docker run --rm \
		--user "$$(id -u):$$(id -g)" \
		-v "$(ROOT_DIR):/workspace" \
		-w /workspace/mail \
		$(CODEGEN_IMAGE) \
		protoc \
			-I . \
			--go_out=langs/go \
			--go_opt=paths=source_relative \
			--go-grpc_out=langs/go \
			--go-grpc_opt=paths=source_relative,require_unimplemented_servers=false \
			--grpc-gateway_out=langs/go \
			--grpc-gateway_opt=paths=source_relative,generate_unbound_methods=true \
			--openapiv2_out=langs/openapi \
			--openapiv2_opt=generate_unbound_methods=true \
			mail.proto
	@echo "Mail contracts generation completed"

clean:
	rm -rf langs
