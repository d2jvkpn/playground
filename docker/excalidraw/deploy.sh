#! /usr/bin/env bash
set -eu -o pipefail

####
export HTTP_Port=$1
td=$HOME/docker_prod/excalidraw
mkdir -p $td
envsubst < deploy.yaml > $td/docker-compose.yaml

####
cd $td
docker-compose pull
docker-compose up -d

docker logs excalidraw

xdg-open http://localhost:$HTTP_Port

####
exit

docker run --detach         \
  --name excalidraw_service \
  --restart=always          \
  --publish=${HTTP_Port}:80 \
  excalidraw/excalidraw:latest
