#! /usr/bin/env bash
set -eu -o pipefail
# set -x
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

export APP_Name=demo-api IMAGE_Tag=dev APP_Tag=dev UserID=$(id -u) HTTP_Port=5032 RPC_Port=5042

envsubst > docker-compose.yaml < deployments/docker_deploy.yaml

mkdir -p logs
docker-compose up -d
