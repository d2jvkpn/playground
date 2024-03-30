#!/bin/bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

export JUPYTER_Port=$1 JUPYTER_Password=$2

envsubst < $(dirname $0)/docker_deploy.yaml > docker-compose.yaml

docker-compose pull
docker-compose up -d
