#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})


REDIS_Port=${1:-6379}
mkdir -p data/redis

touch data/redis/aclfile.acl

if [ ! -f configs/redis.pass ]; then
    password=$(tr -dc 'A-Za-z0-9!@#$%^&*()' < /dev/urandom | head -c 24 || true)
    mkdir -p configs/
    echo "$password" > configs/redis.pass
fi

[ -f data/redis/redis.conf ] || \
cat > data/redis/redis.conf <<EOF
requirepass "$password"

logfile /data/redis-server.log
dir /data
dbfilename dump.rdb

aof-use-rdb-preamble yes
proto-max-bulk-len 32mb
io-threads 4
io-threads-do-reads yes
EOF

export USER_UID=$(id -u) USER_GID=$(id -g) REDIS_Port=$REDIS_Port
envsubst < compose.template.yaml > docker-compose.yaml

docker-compose up -d
