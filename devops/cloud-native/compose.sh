#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


mkdir -p configs logs data/prometheus data/grafana data/jaeger-badger

cp examples/otel-collector.yaml examples/prometheus.yaml configs/

export USER_UID=$(id -u) USER_GID=$(id -g)
envsubst < compose.cloud-native.yaml > compose.yaml

exit
# docker network create grafana
docker-compose up -d
