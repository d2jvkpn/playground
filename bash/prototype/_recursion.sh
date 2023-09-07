#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})


if [ $# -eq 0 ]; then
    >&2 echo "arg(s) not provided!"
    exit 1
elif [ $# -eq 1 ]; then
    arg=$1
else
    for arg in $*; do
        bash $0 $arg
    done
    exit 0
fi

>&2 echo "[$(date +%FT%T.%N%:z)] ==> arg: $arg"

sleep 0.42

#### more codes...

exit 0

Hello, world!
