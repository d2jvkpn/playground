#!/bin/bash
set -eu -o pipefail

####
export HTTP_Port=$1

envsubst < docker_deploy.yaml > docker-compose.yaml

####
docker-compose pull
docker-compose up -d

docker logs excalidraw

xdg-open http://localhost:$HTTP_Port

####
exit

docker run --detach         \
  --name excalidraw         \
  --restart=always          \
  --publish=${HTTP_Port}:80 \
  excalidraw/excalidraw:latest
