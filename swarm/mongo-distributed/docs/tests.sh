#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

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
