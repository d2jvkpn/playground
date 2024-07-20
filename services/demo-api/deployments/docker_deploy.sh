#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

command -v yq > /dev/null


export IMAGE_Tag=$1 HTTP_Port=$2 SWAGGER_Port=$3

export APP_Name=$(yq .app_name project.yaml)
export IMAGE_Name=$(yq .image_name project.yaml)
export USER_UID=$(id -u) USER_GID=$(id -g)

mkdir -p configs logs data/$APP_Name data/postgres data/redis
envsubst < ${_path}/docker_deploy.yaml > docker-compose.yaml

####
exit 0
dry_run=${dry_run:-"false"}

[[ "$dry_run" == "true" ]] && { >&2 echo "exit"; exit 0; }
# docker-compose pull

>&2 echo "==> docker up"
docker-compose up -d

####
exit 0
container=xxxx
# 'docker-compose down' removes running containers only, not stopped containers
[ ! -z "$(docker ps --all --quiet --filter name=$container)" ] && docker rm -f $container

docker stop $container
docker rm $container
