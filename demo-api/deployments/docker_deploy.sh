#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

export TAG=$1 APP_ENV=$2 PORT=$3
app=$(yq .app project.yaml)

mkdir -p configs logs data
envsubst < ${_path}/docker_deploy.yaml > docker-compose.yaml

# docker-compose pull
[ ! -z "$(docker ps --all --quiet --filter name=${app}_${APP_ENV})" ] &&
  docker rm -f ${name}_$APP_ENV
# docker-compose down for running containers only, not stopped containers

docker-compose up -d
