#!/usr/bin/env bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

[ "$EUID" -ne 0 ] && {
    >&2 echo "Please run as root"
    exit 1
}
