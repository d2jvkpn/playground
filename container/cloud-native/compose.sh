#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

export USER_UID=$(id -u) USER_GID=$(id -g)

mkdir -p configs logs data/prometheus data/grafana data/badger

cp examples/{otel-collector.yaml,prometheus.yaml} configs/

envsubst < compose.template.yaml > compose.yaml

exit
# docker network create grafana
docker-compose up -d
