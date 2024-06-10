#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

remote_host=$1
image=$2

base=$(basename $image | sed 's/:/_/g')

ssh $remote_host "set -e; docker pull $image; docker save $image -o $base.tar; pigz $base.tar"
rsync -arvP $remote_host:$base.tar.gz /tmp/

pigz -dc /tmp/$base.tar.gz | docker load

ssh $remote_host "rm $base.tar.gz; docker rmi $image || true"

rm /tmp/$base.tar.gz
docker images --quiet --filter "dangling=true" ${image%:*} | xargs -i docker rmi {} || true
