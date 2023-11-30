#! /usr/bin/env bash
set -eu -o pipefail

_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})
# set -x

function elapsed() {
    t0=$1
    t1=$(date +%s)
    delta=$(($t1 - $t0))

    echo "$((delta/60))m$((delta%60))s"
}

elapsed $1
