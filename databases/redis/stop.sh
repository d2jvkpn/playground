#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


container=$(yq .services.redis.container_name compose.yaml)

cat > data/redis/archive.cmd <<EOF
AUTH $(cat configs/redis.pass)
BGSAVE
BGREWRITEAOF
EOF

docker exec $container sh -c "redis-cli < /data/archive.cmd"

docker stop redis

exit
export REDISCLI_AUTH=$(awk '{print $2}' configs/redis.pass) redis-cli

redis-cli -a yourpassword
