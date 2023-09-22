#! /usr/bin/env bash
set -eu -o pipefail

#### config
wd=$(pwd)
path=$(dirname $0)/
TAG="$1"
PORT="$2"

# docker pull $image
export TAG=${TAG}
export PORT=${PORT}
envsubst < ${path}deploy.yaml > docker-compose.yaml

docker-compose pull
docker-compose up -d
