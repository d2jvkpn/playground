#!/usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

TAG="$1"; APP_ENV="$TAG"; PORT="$2"
# APP_ENV="$2"

#### deploy
export TAG="${TAG}" APP_ENV="${APP_ENV}" PORT="${PORT}"
envsubst < ${_path}/deploy_deploy.yaml > docker-compose.yaml

docker-compose pull
docker-compose up -d

docker logs react-web_${APP_ENV}
