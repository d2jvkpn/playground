#!/bin/bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

port=$1

export PORT=$port

envsubst < ${_path}/docker_deploy.yaml > docker-compose.yaml

docker-compose pull
docker-compose up -d
