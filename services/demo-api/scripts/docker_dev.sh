#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

export APP_Name=demo-api IMAGE_Tag=dev APP_Tag=dev HTTP_Port=5032 RPC_Port=5042
export APP_Name=$(yq .app project.yaml)
export USER_ID=$(id -u) USER_GID=$(id -g)

envsubst > docker-compose.yaml < deployments/docker_deploy.yaml

mkdir -p logs
docker-compose up -d
