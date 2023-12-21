#! /usr/bin/env bash
set -eu -o pipefail

_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})
# set -x

GroupID=${GroupID:-""}
[ ! -z "$GroupID" ] && groupadd -g $GroupID guest || true

source /app/venv/bin/activate

exec "$@"
