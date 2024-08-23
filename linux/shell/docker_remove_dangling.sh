#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

# echo "Hello, world!"

# docker images --filter "dangling=true" --quiet $image | xargs -i docker rmi {}

docker images --filter "dangling=true" --quiet | xargs -i docker rmi {}
