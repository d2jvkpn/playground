#!/usr/bin/env bash
set -eu -o pipefail;_wd=$(pwd); _path=$(dirname $0)

mkdir -p logs/supervisor logs/nginx data/postgres data/redis
  data/chen data/download data/jumpserver data/koko data/lion

cp ${_path}/compose.jumpserver.yaml compose.yaml

exit
cp examples/redis.conf data/redis

docker-compose up -d

exit
#### jumpserver-all
# min length: 50
SECRET_KEY
# min length: 24
BOOTSTRAP_TOKEN

DB_PASSWORD
REDIS_PASSWORD

#### jumpserver-postgres
POSTGRES_PASSWORD

#### copy configs of nginx
docker cp jumpserver-all:/etc/nginx/conf.d configs/
