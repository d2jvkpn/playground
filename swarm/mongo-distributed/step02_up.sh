#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

# [ -z "$(docker network ls | grep -w mongo-distributed)" ] && \
#   docker network create mongo-distributed

cp docker_deploy.yaml docker-compose.yaml

echo "==> docker-compose up"
docker-compose up -d configsvr-1{a..c} shard-{1..3}{a..c}
# docker-compose up -d

# if you start services mongos in docker-compose.yaml, you can't connect to mongos through ports mapping

echo "==> create mongo-mongos-{1..3}"

for idx in {1..3}; do
    node=mongos-$idx
    port=2702$idx

    docker run --name mongo-$node -d \
      -p 127.0.0.1:$port:27017 \
      --net=mongo-distributed \
      --user=$(id -u):$(id -g) \
      -e TZ=Asia/Shanghai \
      -v $PWD/configs:/app/configs \
      -v $PWD/bin:/app/bin \
      -v $PWD/data/$node/db:/app/db \
      -v $PWD/data/$node/logs:/app/logs \
      --entrypoint=mongos \
      mongo:6 --config /app/configs/$node.conf
done
