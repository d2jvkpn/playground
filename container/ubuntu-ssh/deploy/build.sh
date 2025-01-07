#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

docker build -f ${_path}/Containerfile --no-cache -t ubuntu-ssh:local ./

for img in $(docker images --filter=dangling=true --filter=label=app=ubuntu-ssh --quiet); do
    >&2 echo "==> remove image: $img"
    docker rmi $img || true
done
