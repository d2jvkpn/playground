#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

####
for node in 1 2 3; do
    docker run --name mongo-configsvr-$node -d \
      --net=mongo-cluster \
      --user=$(id -u):$(id -g) \
      -v $PWD/configs:/data/configs \
      -v $PWD/scripts:/data/scripts \
      -v $PWD/data/configsvr-${node}/db:/data/db \
      -v $PWD/data/configsvr-${node}/logs:/data/logs \
      mongo:7 --config /data/configs/configsvr.conf
done

####
# docker exec -it mongo-configsvr-1 mongosh -port 27017
docker exec mongo-configsvr-1 mongosh mongodb://127.0.0.1:27017 /data/scripts/configsvr.js

docker exec mongo-configsvr-1 mongosh mongodb://127.0.0.1:27017/admin --eval "rs.isMaster()"

# try again if error "MongoServerError: not primary" occurs
echo root |
  docker exec mongo-configsvr-1 mongosh mongodb://127.0.0.1:27017 /data/scripts/create-user.js

# docker exec -it mongo-configsvr-1 mongosh mongodb://root@127.0.0.1:27017/admin
# docker exec -it mongo-configsvr-2 mongosh mongodb://root@127.0.0.1:27017/admin
# docker exec -it mongo-configsvr-3 mongosh mongodb://root@127.0.0.1:27017/admin
