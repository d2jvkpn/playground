#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


version=$(docker run --rm -it local/opencode:latest opencode --version | dos2unix)

docker tag local/opencode:latest local/opencode:v$version

echo "local/opencode:v$version"
