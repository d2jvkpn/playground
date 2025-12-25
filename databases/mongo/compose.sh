#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


DB_Port=${1:-27017}

mkdir -p data/mongo configs

[ ! -s configs/mongo.pass ] &&
  tr -dc 'a-zA-Z0-9' < /dev/urandom | fold -w 32 | head -n1 > configs/mongo.pass || true

export DB_Port=$DB_Port

envsubst < compose.template.yaml > compose.yaml

exit
docker-compose up -d
