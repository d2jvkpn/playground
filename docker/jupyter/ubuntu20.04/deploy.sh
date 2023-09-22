#! /usr/bin/env bash
set -eu -o pipefail

export JUPYTER_Port=$1
export JUPYTER_Password=$2
envsubst < $(dirname $0)/deploy.yaml > docker-compose.yaml

docker-compose pull
docker-compose up -d
