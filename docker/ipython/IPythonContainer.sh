#! /usr/bin/env bash
set -eu -o pipefail

_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})
# set -x

UserID=$(id -u); GroupID=$(id -g)
mount_path=${mount_path:-data}
mount_path=$(readline -f $mount_path)

mkdir -p $mount_path

docker run -d --name ipython -v $mount_path:/app/data \
  --user ${UserID}:${GroupID} -v GroupID=${GroupID} \
  registry.cn-shanghai.aliyuncs.com/d2jvkpn/ipython:dev sleep infinity
