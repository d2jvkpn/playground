#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

cp deploy_external.yaml docker-compose.yaml
docker-compose up -d
docker-compose ps

ls -1 data/kafka-node*/configs/server.properties \
   data/kafka-node*/data/meta.properties \
   data/kafka-node*/logs
