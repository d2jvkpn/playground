#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})
# set -x

USER_UID=$(id -u); USER_GID=$(id -g)
mount_path=$(readline -f ${mount_path:-data})

mkdir -p $mount_path

docker run -d --name ipython -v $mount_path:/app/data \
  --user ${USER_UID}:${USER_GID} -v USER_GID=${USER_GID} \
  registry.cn-shanghai.aliyuncs.com/d2jvkpn/ipython:dev sleep infinity
