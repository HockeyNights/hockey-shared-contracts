FROM golang:1.26-alpine AS plugins

ARG PROTOC_GEN_GO_VERSION=v1.36.11
ARG PROTOC_GEN_GO_GRPC_VERSION=v1.5.1
ARG GRPC_GATEWAY_VERSION=v2.30.0
ARG GNOSTIC_VERSION=v0.7.0

RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@${PROTOC_GEN_GO_VERSION} \
 && go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@${PROTOC_GEN_GO_GRPC_VERSION} \
 && go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway@${GRPC_GATEWAY_VERSION} \
 && go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2@${GRPC_GATEWAY_VERSION} \
 && go install github.com/google/gnostic/cmd/protoc-gen-openapi@${GNOSTIC_VERSION}

FROM alpine:3.22

RUN apk add --no-cache protobuf protobuf-dev

COPY --from=plugins /go/bin/protoc-gen-go /usr/local/bin/
COPY --from=plugins /go/bin/protoc-gen-go-grpc /usr/local/bin/
COPY --from=plugins /go/bin/protoc-gen-grpc-gateway /usr/local/bin/
COPY --from=plugins /go/bin/protoc-gen-openapiv2 /usr/local/bin/
COPY --from=plugins /go/bin/protoc-gen-openapi /usr/local/bin/

WORKDIR /src
