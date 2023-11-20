#! /usr/bin/env bash
set -eu -o pipefail

####
export HTTP_Port=$1
td=$HOME/docker_dev/node-red
mkdir -p $td
envsubst < deployment.yaml > $td/docker-compose.yaml

####
cd $td
docker-compose pull
docker-compose up -d

docker logs node-red_service

xdg-open http://localhost:$HTTP_Port

####
exit

docker run --detach           \
  --name node-red_service     \
  --publish=${HTTP_Port}:1880 \
  -v data:/data nodered/node-red
