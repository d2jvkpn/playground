#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

export TAG=3.6.0 GID=$(id -g)

envsubst > docker-compose.yaml < deploy_external.yaml

docker-compose up -d
docker-compose ps

sleep 5

ls -1 data/kafka-node*/configs/server.properties \
   data/kafka-node*/data/meta.properties \
   data/kafka-node*/logs
