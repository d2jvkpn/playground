#! /usr/bin/env bash
set -eu -o pipefail
# set -x
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

mkdir -p configs data/prometheus data/grafana

cp jaeger_auth.yaml otel-collector.yaml prometheus_config.yaml prometheus_web.yaml configs/
cp docker_deploy.yaml docker-compose.yaml

mkdir -p logs
# docker network create grafana
docker-compose up -d