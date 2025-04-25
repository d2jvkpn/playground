#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


[ "$EUID" -ne 0 ] && {
    >&2 echo "Please run as root"
    exit 1
}
