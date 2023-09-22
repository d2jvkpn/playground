#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

#### configsvr
docker exec mongo-configsvr-1a mongosh mongodb://127.0.0.1:27017 --quiet \
  --eval 'var configsvr_id="configsvr-1";' /data/scripts/configsvr.js

# docker exec mongo-configsvr-1a mongosh mongodb://127.0.0.1:27017/admin --quiet --eval "rs.isMaster()"
configsvr_cmd="docker exec mongo-configsvr-1a mongosh mongodb://127.0.0.1:27017/admin --quiet"

until [ "$($configsvr_cmd --eval "rs.isMaster().isWritablePrimary")" == "true" ]; do
    echo "==> mongo-configsvr-1a isn't master yet"
    sleep 1
done

echo "==> mongo-configsvr-1a run create-root.js"
$configsvr_cmd /data/scripts/create-root.js

#### shard
for shard in shard-{1,2,3}; do
    docker exec mongo-${shard}a mongosh \
      mongodb://127.0.0.1:27017 --quiet --eval "var shard='$shard';" /data/scripts/shard.js
done

for node in mongo-shard-{1..3}a; do
    cmd="docker exec $node mongosh mongodb://127.0.0.1:27017 --quiet"

    until [ "$($cmd --eval "rs.isMaster().isWritablePrimary")" == "true" ]; do
        echo "==> $node isn't master yet"
        sleep 1
    done

    echo "==> $node run create-root.js"
    $cmd /data/scripts/create-root.js
done

#### mongos
# echo root | docker exec -i mongo-mongos-1 mongosh \
#   mongodb://root@localhost:27017/admin --quiet /data/scripts/mongos.js

docker exec mongo-mongos-1 mongosh /data/scripts/mongos.js

awk '{print $1; exit}' configs/secret.txt |
  docker exec -i mongo-mongos-1 mongosh mongodb://root@localhost:27017/admin \
  --eval "db.adminCommand({listShards: 1})"

# docker exec -it mongo-mongos-1 mongosh mongodb://root@mongo-mongos-1/admin \
#   --eval "db.adminCommand({listShards: 1})"

# docker exec -it mongo-mongos-1 mongosh mongodb://root@mongo-mongos-2/admin \
#   --eval "db.adminCommand({listShards: 1})"
