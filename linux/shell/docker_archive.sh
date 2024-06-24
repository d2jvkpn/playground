#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})


image=$1
repository=$(yq .repository ~/.docker/docker_archive.yaml | sed 's#/$##')

target=$repository/$(basename $image)

echo "==> target: $target"

docker tag $image $target
docker push $target
docker rmi $target
