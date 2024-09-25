#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

# echo "Hello, world!"

export USER_UID=$(id -u) USER_GID=$(id -g)

mkdir -p logs data/metube configs

envsubst < docker_deploy.yaml > docker-compose.yaml
