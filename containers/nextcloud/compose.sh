#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


HTTP_Port=${1:-3031}

mkdir -p data/nextcloud data/postgres

POSTGRES_Password=$(tr -dc "0-9a-zA-Z" < /dev/urandom | fold -w 32 | head -n 1 || true)

export USER_UID=$(id -u) USER_GID=$(id -g)
export HTTP_Port=$HTTP_Port POSTGRES_Password=${POSTGRES_Password}

envsubst < compose.nextcloud.yaml > compose.yaml

exit
docker-compose up -d
sleep 5
docker-compose logs

sed -i 's/  env_file/  # env_file/' compose.yaml
