#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

remote_host=$1
image=$2

remove=${remove:-false}

base=$(basename $image | sed 's/:/_/g')

ssh $remote_host "set -e; docker pull $image; docker save $image -o $base.tar; pigz $base.tar"

rsync -arvP $remote_host:$base.tar.gz /tmp/
ssh $remote_host "rm $base.tar.gz"

pigz -dc /tmp/$base.tar.gz | docker load

[[ "$remove" == "true" ]] && {
    ssh $remote_host "docker rmi $image || true";
    rm /tmp/$base.tar.gz;
}

docker images --quiet --filter "dangling=true" ${image%:*} | xargs -i docker rmi {} || true
