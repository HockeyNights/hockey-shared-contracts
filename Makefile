.PHONY: generate-all generate-auth generate-mail clean

generate-all: generate-auth generate-mail

generate-auth:
	$(MAKE) -C auth generate

generate-mail:
	$(MAKE) -C mail generate

clean:
	$(MAKE) -C auth clean
	$(MAKE) -C mail clean
