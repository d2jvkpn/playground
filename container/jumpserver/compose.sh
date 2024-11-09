#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

mkdir -p logs/supervisor logs/nginx \
  data/chen data/download data/jumpserver data/koko data/lion \
  data/postgres data/redis

[ -f data/redis/redis.conf ] || cp redis.conf data/redis/

cp containers.yaml docker-compose.yaml

docker-compose up -d
