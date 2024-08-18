#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})


REDIS_Port=${1:-6379}
mkdir -p configs data/redis
touch data/redis/aclfile.acl

password=$(tr -dc 'A-Za-z0-9!@#$%^&*()' < /dev/urandom | head -c 24 || true)

[ -f configs/redis.password ] || echo "$password" > configs/redis.password

[ -f configs/redis.conf ] || \
cat > configs/redis.conf <<EOF
requirepass "$password"

logfile /app/data/redis-server.log
dir /app/data
dbfilename dump.rdb

aof-use-rdb-preamble yes
proto-max-bulk-len 32mb
io-threads 4
io-threads-do-reads yes
EOF

export USER_UID=$(id -u) USER_GID=$(id -g) REDIS_Port=$REDIS_Port
envsubst < docker_deploy.yaml > docker-compose.yaml

docker-compose up -d
