#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

command -v swag || go install github.com/swaggo/swag/cmd/swag@latest

if [[ "${_wd}" == "${_path}" ]]; then
    echo "==> swag cd to target dir: ../"
    cd ../
fi

# swag_dir=swagger/docs
swag_dir=${_path}/docs
echo "==> swag dir: $swag_dir"

swag init --output $swag_dir

# --exclude ./internal
swag fmt --dir $swag_dir

echo "<== swag done"
