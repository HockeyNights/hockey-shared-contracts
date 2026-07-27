FROM golang:1.25-alpine

RUN apk add --no-cache git protobuf protobuf-dev \
    && git clone --depth 1 https://github.com/googleapis/googleapis.git /googleapis \
    && go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.36.10 \
    && go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.5.1 \
    && go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway@v2.27.3 \
    && go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2@v2.27.3

ENV PATH="/go/bin:${PATH}"

WORKDIR /workspace
