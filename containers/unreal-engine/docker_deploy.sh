#!/bin/bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

UE_App=$1; WS_Url=$2

export UE_App=$UE_App WS_Url=$WS_Url USER_UID=$(id -u) USE_GID=$(id -g)

envsubst < docker_deploy.yaml > docker-compose.yaml

docker-compose pull
docker-compose up -d
