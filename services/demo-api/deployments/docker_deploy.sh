#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

export IMAGE_Tag=${1:-dev} HTTP_Port=${2:-5030} RPC_Port={3:-5040}

export APP_Name=$(yq .app_name project.yaml)
export IMAGE_Name=$(yq .image_name project.yaml)
export USER_UID=$(id -u) USER_GID=$(id -g)

container=${APP_Name}_${APP_Tag}
dry_run=${dry_run:-false}

mkdir -p configs logs data
envsubst < ${_path}/docker_deploy.yaml > docker-compose.yaml

[[ "$dry_run" == "true" ]] && { >&2 echo "exit"; exit; }

# docker-compose pull
[ ! -z "$(docker ps --all --quiet --filter name=$container)" ] && docker rm -f $container
# 'docker-compose down' removes running containers only, not stopped containers

docker-compose up -d

exit 0

docker stop $container && docker stop $container
docker rm -f $container
