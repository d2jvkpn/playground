#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

DB_Port=${1:-27017}

mkdir -p data/mongo

export DB_Port=$DB_Port
envsubst < compose.mongo.yaml > compose.yaml

docker-compose up -d
