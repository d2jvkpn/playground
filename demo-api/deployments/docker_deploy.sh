#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

app_name=$(yq .app project.yaml)
export TAG=$1 APP_ENV=$2 PORT=$3 APP_Name=$app_name

mkdir -p configs logs data
envsubst < ${_path}/docker_deploy.yaml > docker-compose.yaml

# docker-compose pull
[ ! -z "$(docker ps --all --quiet --filter name=${app_name}_${APP_ENV})" ] &&
  docker rm -f ${app_name}_$APP_ENV
# docker-compose down for running containers only, not stopped containers

docker-compose up -d
