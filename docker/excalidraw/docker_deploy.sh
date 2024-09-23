#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

####
HTTP_Port=${1:-4043}

export HTTP_Port=$HTTP_Port
export USER_UID=$(id -u) USER_GID=$(id -g)

mkdir -p logs configs data/caddy/data data/caddy/config

envsubst < docker_deploy.yaml > docker-compose.yaml

exit
####
docker-compose pull
docker-compose up -d

docker-compose logs

docker logs excalidraw-app

xdg-open http://localhost:4043

####
exit

docker run --detach         \
  --name excalidraw         \
  --restart=always          \
  --publish=${HTTP_Port}:80 \
  excalidraw/excalidraw:latest

docker run --rm -it caddy:2-alpine caddy hash-password --plaintext excalidraw
