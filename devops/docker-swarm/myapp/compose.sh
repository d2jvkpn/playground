#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


docker swarm init

docker stack deploy -c compose.yaml myapp

docker-compose build

docker stack deploy -c compose.yaml myapp
