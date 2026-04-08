#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


version=$(docker run --rm local/claude-code:latest claude --version | awk '{print $1}')
docker tag local/claude-code:latest local/claude-code:$version
echo "local/claude-code:$version"
