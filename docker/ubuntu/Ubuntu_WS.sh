#!/bin/bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})
# set -x

container_name=ubuntu-ws_$(tr -dc 'a-z0-9' < /dev/random | fold -w 16 | head -n1 || true)

mount_path=${mount_path:-""}
uid=$(id -u)
gid=$(id -g)

echo "==> mount_path: $mount_path"

# set -x

if [ -z "$mount_path" ]; then
    docker run -d --name $container_name -u $uid:$gid -w /app \
      ubuntu:22.04 tail -f /etc/hosts
else
    mount_path=$(readlink -f $mount_path)
    docker run -d --name $container_name -u $uid:$gid -w /app -v $mount_path:/app \
      ubuntu:22.04 sleep infinity
fi

echo "docker exec -it $container_name bash"
