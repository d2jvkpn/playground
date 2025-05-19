#!/usr/bin/env bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


REDIS_Port=${1:-6379}
mkdir -p data/redis

if [ ! -s configs/redis.pass ]; then
    # password=$(tr -dc 'A-Za-z0-9!@#$%^&*()' < /dev/urandom | head -c 24 || true)
    password=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 32 || true)
    mkdir -p configs/
    echo "$password" > configs/redis.pass
fi

password=$(cat configs/redis.pass)

[ -s data/redis/redis.conf ] ||
  PASSWORD=$password envsubst < redis.conf > data/redis/redis.conf

export USER_UID=$(id -u) USER_GID=$(id -g) REDIS_Port=$REDIS_Port
envsubst < compose.redis.yaml > compose.yaml

exit
docker-compose up -d

wget -O redis.default.conf https://download.redis.io/redis-stable/redis.conf
