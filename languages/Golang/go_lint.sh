#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

# echo "Hello, world!"
go mod tidy
if [ -d vendor ]; then go mod vendor; fi
go fmt ./...
go vet ./...
