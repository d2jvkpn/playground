#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


version=$(docker run --rm -it q.local/opencode:latest opencode --version | dos2unix)

docker tag q.local/opencode:latest q.local/opencode:$version

echo "q.local/opencode:$version"
