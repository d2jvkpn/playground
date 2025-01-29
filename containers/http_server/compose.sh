#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

export USER_UID=$(id -u) USER_GID=$(id -g) HTTP_Port=${1:-8000}

mkdir -p data/http_server

envsubst < compose.template.yaml > compose.yaml
