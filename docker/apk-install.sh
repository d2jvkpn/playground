#! /usr/bin/env sh
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

apk --no-cache update && apk --no-cache upgrade

apk --no-cache add tzdata $*
