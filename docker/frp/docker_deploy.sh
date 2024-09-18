#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

export USER_UID=$(id -u) USER_GID=$(id -g)

cmd=$1

case "$cmd" in
"client")
    echo "==> client"
    ;;
"server")
    echo "==> server"
    ;;
*)
    >&2 echo "unknown cmd"
    exit 1
    ;;
esac

mkdir -p configs logs
ls configs/frp_${cmd}.toml

envsubst < ${_path}/docker_deploy.$cmd.yaml > docker-compose.yaml

echo "==> docker-compose.yaml"

cat docker-compose.yaml
