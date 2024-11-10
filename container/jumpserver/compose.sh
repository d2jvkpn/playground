#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

mkdir -p logs/supervisor logs/nginx \
  data/chen data/download data/jumpserver data/koko data/lion \
  data/postgres data/redis

cp ${_path}/compose.template.yaml compose.yaml

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
