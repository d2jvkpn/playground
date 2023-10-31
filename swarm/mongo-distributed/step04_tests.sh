#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

#### create user hello and database backend
awk '{print $1; exit}' configs/secret.txt | docker exec -i mongo-mongos-1 mongosh \
  mongodb://root@mongo-mongos-1:27017,mongo-mongos-2:27017,mongo-mongos-3:27017/admin \
  /app/bin/tests.js

echo "world" | docker exec -i mongo-mongos-1 mongosh \
  mongodb://hello@mongo-mongos-1:27017,mongo-mongos-2:27017,mongo-mongos-3:27017/backend \
  --quiet --eval 'use backend' --eval 'db.getCollection("accounts").find()'

exit

#### connected to mongos
docker exec -it mongo-mongos-1 mongosh \
  mongodb://root@mongo-mongos-1:27017,mongo-mongos-2:27017,mongo-mongos-3:27017/admin

docker exec -it mongo-mongos-1 mongosh \
  mongodb://hello@mongo-mongos-1:27017,mongo-mongos-2:27017,mongo-mongos-3:27017/backend

# docker exec -it mongo-mongos-1 mongosh mongodb://root@mongo-mongos-1:27017/admin

# ip=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' mongo-mongos-1)
# mongosh mongodb://root@$ip:27017/admin

# mongosh mongodb://root@127.0.0.1:27021/admin

# docker exec -it mongo-mongos-1 mongosh mongodb://root@mongo-configsvr-1a:27017/admin

#### change password
docker exec -i mongo-mongos-1 mongosh --quiet /app/bin/change-password.js
docker exec -it mongo-configsvr-1a mongosh  mongodb://127.0.0.1:27017/admin --quiet

# db.auth("root", "TheNewPassword");

docker exec -i mongo-shard-1a mongosh --quiet /app/bin/change-password.js
docker exec -i mongo-shard-2a mongosh --quiet /app/bin/change-password.js
docker exec -i mongo-shard-3a mongosh --quiet /app/bin/change-password.js

#### db "local" on shard nodes
docker exec -it mongo-shard-1a mongosh mongodb://root@127.0.0.1:27017/admin \
  --quiet --eval 'use local' --eval 'show collections'

docker exec -it mongo-shard-1a mongosh mongodb://root@mongo-shard-2a:27017/admin \
  --quiet --eval 'use local' --eval 'show collections'

docker exec -it mongo-shard-3a mongosh mongodb://root@127.0.0.1:27017/admin \
  --quiet --eval 'use local' --eval 'show collections'
