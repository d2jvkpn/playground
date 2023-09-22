#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

#### step1: prepare data dirctories, configuration files and scripts
bash 00.sh

#### step2: up cluster containers
docker-compose -f deploy.yaml up -d

#### step 3: config configsvr nodes
docker exec mongo-configsvr-1 mongosh mongodb://127.0.0.1:27017 /data/scripts/configsvr.js

docker exec mongo-configsvr-1 mongosh mongodb://127.0.0.1:27017/admin --eval "rs.isMaster()"
# try again if error "MongoServerError: not primary" occurs
docker exec mongo-configsvr-1 mongosh mongodb://127.0.0.1:27017 /data/scripts/create-user.js

#### step 4: config shard nodes
for shard in 1 2 3; do
    docker exec mongo-shard-${shard}a mongosh \
      mongodb://127.0.0.1:27017 /data/scripts/shard-${shard}.js
done

docker exec mongo-shard-1a mongosh mongodb://127.0.0.1:27017/admin --eval "rs.isMaster()"
docker exec mongo-shard-2a mongosh mongodb://127.0.0.1:27017/admin --eval "rs.isMaster()"
docker exec mongo-shard-3a mongosh mongodb://127.0.0.1:27017/admin --eval "rs.isMaster()"

for shard in 1 2 3; do
    docker exec -it mongo-shard-${shard}a mongosh \
      mongodb://127.0.0.1:27017 /data/scripts/create-user.js
done

#### step 5: add shards to mongos
bash a03_mongos-server.sh

#### step6: tests
docker exec -it mongo-mongos-1 mongosh mongodb://root@mongo-mongos-1:27017/admin
docker exec -it mongo-mongos-1 mongosh mongodb://root@mongo-mongos-2:27017/admin
docker exec -it mongo-mongos-1 mongosh mongodb://root@mongo-configsvr-1:27017/admin

mongosh mongodb://root@127.0.0.1:30001/admin
mongosh mongodb://root@127.0.0.1:30001,127.0.0.1:30002,127.0.0.1:30003/admin
# mongo mongodb://root@127.0.0.1:30001/admin

#### step7: change configsvr root password
docker exec -it mongo-mongos-1 mongosh mongodb://root@mongo-mongos-1:27017/admin \
  --eval 'db.changeUserPassword("root", passwordPrompt());'

docker exec -it mongo-shard-1a mongosh mongodb://root@127.0.0.01:27017/admin \
  --eval 'db.changeUserPassword("root", passwordPrompt());'

docker exec -it mongo-shard-2a mongosh mongodb://root@127.0.0.01:27017/admin \
  --eval 'db.changeUserPassword("root", passwordPrompt());'

docker exec -it mongo-shard-3a mongosh mongodb://root@127.0.0.01:27017/admin \
  --eval 'db.changeUserPassword("root", passwordPrompt());'

#### step8: shutdown
docker-compose -f deploy.yaml down
docker stop mongo-mongos-{1..3} && docker rm mongo-mongos-{1..3}
