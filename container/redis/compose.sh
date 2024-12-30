#!/usr/bin/env bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0) # set -x


REDIS_Port=${1:-6379}
mkdir -p data/redis

if [ ! -s configs/redis.pass ]; then
    # password=$(tr -dc 'A-Za-z0-9!@#$%^&*()' < /dev/urandom | head -c 24 || true)
    password=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 32 || true)
    mkdir -p configs/
    echo "$password" > configs/redis.pass
fi

password=$(cat configs/redis.pass)

[ -s data/redis/redis.conf ] || envsubst < redis.conf > data/redis/redis.conf

export USER_UID=$(id -u) USER_GID=$(id -g) REDIS_Port=$REDIS_Port
envsubst < compose.template.yaml > compose.yaml

docker-compose up -d
