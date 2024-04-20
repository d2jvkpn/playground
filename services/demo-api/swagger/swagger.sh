#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

command -v swag || go install github.com/swaggo/swag/cmd/swag@latest

# swag_dir=swagger/docs
swag_dir=${_path}/docs

swag init --output $swag_dir
swag fmt --dir $swag_dir
# --exclude ./internal
