#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

# https://redis.io/docs/management/scaling/#create-a-redis-cluster

# sudo rm -rf data/redis-node0*/*
mkidr -p configs data/redis-node{01..06}
[ -s configs/redis.conf ] && cp configs/redis.cluster.conf configs/


export USER_UID=$(id -u) USER_GID=$(id -g)
envsubst < docker_deploy.yaml > docker-compose.yaml

docker-compose up -d

docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' redis-node{01..06}

redis_node01='docker exec redis-node01 redis-cli -h 127.0.0.1 -p 6380'

$redis_node01 \
  --cluster create --cluster-replicas 1 --cluster-yes \
  redis-node01:6380 \
  redis-node02:6380 \
  redis-node03:6380 \
  redis-node04:6380 \
  redis-node05:6380 \
  redis-node06:6380

$redis_node01 cluster info

$redis_node01 cluster nodes

$redis_node01 set _fool bar

$redis_node01 cluster help

# $redis_node01 debug segfault

exit
docker exec -it redis-node01 redis-cli -h 127.0.0.1 -p 6380

$redis_node01 --cluster add-node redis-node07:6380 redis-node08:6380 \
  --cluster-slave --cluster-master-id 3c3a0c74aae0b56170ccb03a76b60cfe7dc1912e
