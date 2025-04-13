#!/usr/bin/env bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})


image=$1

yaml=~/.docker/docker_archive.yaml
repository=$(yq .repository $yaml | sed 's#/$##')

target=$repository/$(basename $image)
echo "==> target: $target"

docker tag $image $target
docker push $target

docker rmi $target
yq eval '.images."'$image'" = "'$(date +%FT%T%:z)'"' -i $yaml
