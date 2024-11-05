#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

USER_GID=${USER_GID:-""}
[ ! -z "$USER_GID" ] && groupadd -g $USER_GID guest || true

source /app/venv/bin/activate

exec "$@"
