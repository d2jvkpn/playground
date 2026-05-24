#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


host=$(yq .redis.host configs/local.yaml)
port=$(yq .redis.port configs/local.yaml)
db=$(yq .redis.db configs/local.yaml)
password=$(yq .redis.password configs/local.yaml)

REDISCLI_AUTH="$password" redis-cli -h "$host" -p "$port" -n $db
