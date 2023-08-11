#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

if [ $# -eq 0 ]; then
    echo "arg(s) not provided" 1>&2
    exit 1
elif [ $# -eq 1 ]; then
    arg=$1
else
    for arg in $*; do
        bash $0 $arg
    done    
fi

echo "==> arg: $arg"
sleep 0.42

#### more codes...
