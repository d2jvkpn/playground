#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0)


export USER_UID=$(id -u) USER_GID=$(id -g)

mkdir -p configs logs

envsubst < ${_path}/compose.kcptun-server.yaml > compose.yaml
