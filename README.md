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
