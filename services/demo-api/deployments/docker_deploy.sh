#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

export IMAGE_Tag=$1 APP_Tag=$2 HTTP_Port=$3 RPC_Port=$4
export APP_Name=$(yq .app project.yaml)
export USER_ID=$(id -u) USER_GID=$(id -g)

container=${APP_Name}_${APP_Tag}

mkdir -p configs logs data
envsubst < ${_path}/docker_deploy.yaml > docker-compose.yaml

# docker-compose pull
[ ! -z "$(docker ps --all --quiet --filter name=$container)" ] &&
  docker rm -f $container
# 'docker-compose down' removes running containers only, not stopped containers

USER_ID=$USER_ID USER_GID=$USER_GID docker-compose up -d

exit 0
docker stop $container && docker stop $container
docker rm -f $container
