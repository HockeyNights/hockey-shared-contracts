# Contracts

Репозиторий gRPC-контрактов HockeyNights

Для каждого сервиса используется отдельная директория:

```text
contracts/
  auth/
    auth.proto
    Makefile
    langs/
      go/
      openapi/
```

Для генерации нужен только Docker. `protoc` и плагины устанавливать локально
не требуется.

## Генерация

Сгенерировать все контракты:

```sh
make generate-all
```

Сгенерировать только auth:

```sh
make generate-auth
```

Команду также можно запустить из директории сервиса:

```sh
cd auth
make generate
```

Результат:

```text
auth/langs/go/auth.pb.go
auth/langs/go/auth_grpc.pb.go
auth/langs/go/auth.pb.gw.go
auth/langs/openapi/auth.swagger.json
```

## Auth HTTP paths

Для auth в proto добавлены HTTP-аннотации, поэтому grpc-gateway и OpenAPI
используют человекочитаемые пути:

```text
POST /auth/register
POST /auth/verify-email
POST /auth/resend-verification-code
POST /auth/login
POST /auth/refresh-token
POST /auth/logout
POST /auth/logout-all
POST /auth/validate-token
```
