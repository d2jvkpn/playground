#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

export APP_Name=$(yq .app project.yaml)
export TAG=$1 APP_ENV=$2 HTTP_PORT=$3 RPC_PORT=$4

container=${APP_Name}_${APP_ENV}

mkdir -p configs logs data
envsubst < ${_path}/docker_deploy.yaml > docker-compose.yaml

# docker-compose pull
[ ! -z "$(docker ps --all --quiet --filter name=$container)" ] &&
  docker rm -f $container
# 'docker-compose down' removes running containers only, not stopped containers

UID=$UID GID=$(id -g) docker-compose up -d

exit 0
docker stop $container && docker stop $container
docker rm -f $container
