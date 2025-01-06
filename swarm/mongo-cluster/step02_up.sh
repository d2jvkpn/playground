#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

# [ -z "$(docker network ls | grep -w mongo-cluster)" ] && docker network create mongo-cluster

export USER_UID=$(id -u) USER_GID=$(id -g)
envsubst < compose.template.yaml > compose.yaml

echo "==> docker-compose up"
docker-compose up -d

exit
# if you start services mongos in compose.yaml, you can't connect to mongos through ports mapping
sed -i -e '/mongos-1:\|mongos-2:\|mongos-3:/,+15d' compose.yaml
docker-compose up -d configsvr-1{a..c} shard-{1..3}{a..c}

echo "==> create mongo-mongos-{1..3}"

for idx in {1..3}; do
    node=mongos-$idx
    port=2702$idx

    docker run --name mongo-$node -d \
      -p 127.0.0.1:$port:27017 \
      --net=mongo-cluster \
      -e TZ=Asia/Shanghai \
      -v $PWD/bin:/apps/bin \
      -v $PWD/configs:/apps/configs \
      -v $PWD/data/$node/db:/data/db \
      -v $PWD/data/$node/logs:/var/log/mongodb \
      --entrypoint=mongos \
      mongo:7 --config /apps/configs/$node.conf
done
