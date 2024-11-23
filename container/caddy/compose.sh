#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

HTTP_Port=${1:-4042}
export USER_UID=$(id -u) USER_GID=$(id -g) HTTP_Port=$HTTP_Port

mkdir -p logs configs
mkdir -p data/caddy/data data/caddy/config data/metube

envsubst < compose.template.yaml > compose.yaml

exit
docker-compose pull
docker-compose logs

docker run --detach         \
  --name excalidraw         \
  --restart=always          \
  --publish=${HTTP_Port}:80 \
  excalidraw/excalidraw:latest

xdg-open http://localhost:4042

docker run --rm -it caddy:2-alpine caddy hash-password --plaintext YourPassword
