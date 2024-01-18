#! /usr/bin/env bash
set -eu -o pipefail
# # set -x
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

# echo "Hello, world!"
