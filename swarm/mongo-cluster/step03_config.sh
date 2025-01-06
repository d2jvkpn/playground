#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

#### configsvr
docker exec mongo-configsvr-1a mongosh mongodb://127.0.0.1:27017 --quiet \
  --eval 'var configsvr_id="configsvr-1";' /apps/bin/configsvr.js

# docker exec mongo-configsvr-1a mongosh mongodb://127.0.0.1:27017/admin --quiet --eval "rs.isMaster()"
configsvr_cmd="docker exec mongo-configsvr-1a mongosh mongodb://127.0.0.1:27017/admin --quiet"

until [ "$($configsvr_cmd --eval "rs.isMaster().isWritablePrimary")" == "true" ]; do
    echo "==> mongo-configsvr-1a isn't master yet"
    sleep 1
done

echo "==> mongo-configsvr-1a run create-root.js"
$configsvr_cmd /apps/bin/create-root.js

#### shard
for shard in shard-{1,2,3}; do
    docker exec mongo-${shard}a mongosh \
      mongodb://127.0.0.1:27017 --quiet --eval "var shard='$shard';" /apps/bin/shard.js
done

for node in mongo-shard-{1..3}a; do
    cmd="docker exec $node mongosh mongodb://127.0.0.1:27017 --quiet"

    until [ "$($cmd --eval "rs.isMaster().isWritablePrimary")" == "true" ]; do
        echo "==> $node isn't master yet"
        sleep 1
    done

    echo "==> $node run create-root.js"
    $cmd /apps/bin/create-root.js
done

#### mongos for mongo:7
# echo root | docker exec -i mongo-mongos-1 mongosh \
#   mongodb://root@localhost:27017/admin --quiet /apps/bin/mongos.js

docker exec mongo-mongos-1 mongosh /apps/bin/mongos.js

awk '{print $1; exit}' configs/mongo.secret |
  docker exec -i mongo-mongos-1 mongosh mongodb://root@localhost:27017/admin \
  --eval "db.adminCommand({listShards: 1})"

# docker exec -it mongo-mongos-1 mongosh mongodb://root@mongo-mongos-1/admin \
#   --eval "db.adminCommand({listShards: 1})"

# docker exec -it mongo-mongos-1 mongosh mongodb://root@mongo-mongos-2/admin \
#   --eval "db.adminCommand({listShards: 1})"
