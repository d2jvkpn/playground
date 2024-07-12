#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

export USER_UID=$(id -u) USER_GID=$(id -g)

mkdir -p configs logs data/prometheus data/grafana

cp examples/{jaeger.yaml,otel-collector.yaml,prometheus.yaml,prometheus_web.yaml} configs/

envsubst > docker-compose.yaml < docker_deploy.yaml

exit
# docker network create grafana
docker-compose up -d
