#!/bin/bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

http_port=$1; domain=$2

mkdir -p data/registry

export HTTP_Port=$http_port; DOMAIN=$2

envsubst < ${_path}/docker_deploy.yaml > docker-compose.yaml

docker-compose pull
docker-compose up -d
