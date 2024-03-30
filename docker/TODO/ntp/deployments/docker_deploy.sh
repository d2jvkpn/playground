#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

#### config
TAG="$1"; PORT="$2"

# docker pull $image
export TAG=${TAG} PORT=${PORT}

envsubst < ${path}/docker_deploy.yaml > docker-compose.yaml

docker-compose pull
docker-compose up -d
