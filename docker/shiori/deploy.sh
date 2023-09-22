#! /usr/bin/env bash
set -eu -o pipefail

export PORT=$1
envsubst < $(dirname $0)/deploy.yaml > docker-compose.yaml

docker-compose pull
docker-compose up -d
