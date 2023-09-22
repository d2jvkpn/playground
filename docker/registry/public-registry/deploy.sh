#! /usr/bin/env bash
set -eu -o pipefail

port=$1

export PORT=$port

envsubst < $(dirname $0)/deploy.yaml > docker-compose.yaml

docker-compose pull
docker-compose up -d
