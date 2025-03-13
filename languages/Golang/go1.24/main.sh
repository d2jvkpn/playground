#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


mkdir -p target

go build -o target/main main.go
