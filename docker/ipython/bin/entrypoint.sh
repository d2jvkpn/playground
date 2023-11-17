#! /usr/bin/env bash
set -eu -o pipefail

# _wd=$(pwd)
# _path=$(dirname $0 | xargs -i readlink -f {})
# set -x

source /app/venv/bin/activate

exec "$@"
