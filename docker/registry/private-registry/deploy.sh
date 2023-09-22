#! /usr/bin/env bash
set -eu -o pipefail

port=$1
domain=$2

export PORT=$port
export DOMAIN=$2

envsubst < $(dirname $0)/deployment.yaml > docker-compose.yaml

docker-compose pull
docker-compose up -d
