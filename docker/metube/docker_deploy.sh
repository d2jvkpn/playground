#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

# echo "Hello, world!"

export USER_UID=$(id -u) USER_GID=$(id -g)

mkdir -p logs configs data/metube data/caddy/data data/caddy/config

envsubst < docker_deploy.yaml > docker-compose.yaml

exit

docker run --rm -it caddy:2-alpine caddy hash-password --plaintext metube
