#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

git submodule add git@github.com:d2jvkpn/swagger-go.git swagger-go
 
cat .gitmodules 
