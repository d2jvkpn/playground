#! /usr/bin/env bash
set -eu -o pipefail

export POSTGRES_USER=$1
export POSTGRES_PASSWORD=$2
export PORT=$3

envsubst < $(dirname $0)/deploy.yaml > docker-compose.yaml

docker-compose pull
docker-compose up -d
