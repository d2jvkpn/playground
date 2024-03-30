#!/bin/bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})


mkdir -p data/mongo

docker-compose pull

docker-compose up -d

docker exec yapi_web npm run install-server
