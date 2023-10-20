#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

export APP_Name=$(yq .app project.yaml)
export TAG=$1 APP_ENV=$2 HTTP_PORT=$3 RPC_PORT=$4

mkdir -p configs logs data
envsubst < ${_path}/docker_deploy.yaml > docker-compose.yaml

# docker-compose pull
[ ! -z "$(docker ps --all --quiet --filter name=${APP_Name}_${APP_ENV})" ] &&
  docker rm -f ${APP_Name}_$APP_ENV
# docker-compose down for running containers only, not stopped containers

docker-compose up -d
