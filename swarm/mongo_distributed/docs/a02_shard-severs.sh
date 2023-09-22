#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

####
for shard in 1 2 3; do
    for node in a b c; do
        docker run --name mongo-shard-${shard}${node} -d \
          --net=mongo-cluster \
          --user=$(id -u):$(id -g) \
          -v $PWD/configs:/data/configs \
          -v $PWD/scripts:/data/scripts \
          -v $PWD/data/shard-${shard}${node}/db:/data/db \
          -v $PWD/data/shard-${shard}${node}/logs:/data/logs \
          mongo:6 --config /data/configs/shard-$shard.conf
    done
done

####
for shard in 1 2 3; do
  docker exec -it mongo-shard-${shard}a mongosh \
    mongodb://127.0.0.1:27017 /data/scripts/shard-${shard}.js
done

docker exec mongo-shard-1a mongosh mongodb://127.0.0.1:27017/admin --eval "rs.isMaster()"
docker exec mongo-shard-2a mongosh mongodb://127.0.0.1:27017/admin --eval "rs.isMaster()"
docker exec mongo-shard-3a mongosh mongodb://127.0.0.1:27017/admin --eval "rs.isMaster()"

for shard in 1 2 3; do
  docker exec -it mongo-shard-${shard}a mongosh \
    mongodb://127.0.0.1:27017 /data/scripts/create-user.js
done

# docker exec -it mongo-shard-2a mongosh mongodb://root@127.0.0.1:27017/admin
# docker exec -it mongo-shard-2a mongosh mongodb://root@mongo-shard-2a:27017/admin
# docker exec -it mongo-shard-2a mongosh mongodb://root@mongo-shard-2b:27017/admin
