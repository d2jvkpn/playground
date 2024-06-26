#!/bin/bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

# TAG="$1"
APP_ENV="$1"; TAG=$APP_ENV; HTTP_Port="$2"

#### deploy
export TAG="${TAG}" APP_ENV="${APP_ENV}" HTTP_Port="${HTTP_Port}"
envsubst < ${_path}/docker_deploy.yaml > docker-compose.yaml

docker-compose pull
docker-compose up -d

docker logs vue-web_${APP_ENV}
