#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

####
image=$1
for img in $(docker images --filter "dangling=true" --quiet $image); do
    docker rmi $img || true
done &> /dev/null

####
docker ps -f status=exited -q | xargs -i docker rm {}
docker images -f dangling=true -q | xargs -i docker rmi {}
