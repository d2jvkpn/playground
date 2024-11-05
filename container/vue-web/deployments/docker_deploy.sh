#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

IMAGE_Tag="$1"; HTTP_Port="$2"

#### deploy
export IMAGE_Tag="${IMAGE_Tag}" HTTP_Port="${HTTP_Port}"

envsubst < ${_path}/docker_deploy.yaml > docker-compose.yaml

exit 0

docker-compose pull
docker-compose up -d
docker logs vue-web
