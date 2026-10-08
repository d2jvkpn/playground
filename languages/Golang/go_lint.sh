#!/usr/bin/env bash

# echo "Hello, world!"
go mod tidy
if [ -d vendor ]; then go mod vendor; fi
go fmt ./...
go vet ./...

go env -w GOPROXY="https://goproxy.cn,direct"
