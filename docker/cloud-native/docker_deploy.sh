#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

mkdir -p configs logs data/prometheus data/grafana

cp examples/{jaeger.yaml,otel-collector.yaml,prometheus.yaml,prometheus_web.yaml} configs/
cp docker_deploy.yaml docker-compose.yaml

# docker network create grafana
docker-compose up -d
