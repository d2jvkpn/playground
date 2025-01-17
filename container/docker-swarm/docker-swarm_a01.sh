#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


exit
docker service create --name redis --replicas 3 --publish 16379:6379 redis:7-alpine

docker swarm join --token <token>

docker swarm join-token manager
