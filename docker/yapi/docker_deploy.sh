#!/bin/bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

HTTP_Port=${1:-3000}

mkdir -p data/mongo

HTTP_Port=$HTTP_Port envsubst < docker_deploy.yaml > docker-compose.yaml

# docker-compose pull
docker-compose up -d

sleep 3
docker exec yapi-web npm run install-server
