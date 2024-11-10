#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

mkdir -p logs/supervisor logs/nginx \
  data/chen data/download data/jumpserver data/koko data/lion \
  data/postgres data/redis

cp containers.yaml docker-compose.yaml

exit
cp examples/redis.conf data/redis

docker-compose up -d

exit
# min length: 50
SECRET_KEY
# min length: 24
BOOTSTRAP_TOKEN

DB_PASSWORD
REDIS_PASSWORD

POSTGRES_PASSWORD

docker cp jumpserver-all:/etc/nginx/conf.d configs/
