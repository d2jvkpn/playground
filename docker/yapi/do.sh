#! /usr/bin/env bash
set -eu -o pipefail

_wd=$(pwd)/
_path=$(dirname $0)/


mkdir -p data/mongo

docker-compose pull

docker-compose up -d

docker exec yapi_web npm run install-server
