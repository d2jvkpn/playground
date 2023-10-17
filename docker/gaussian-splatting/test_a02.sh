#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

if [ $# -eq 0 ]; then
    :
elif [ $# -eq 1 ]; then
    cd $1
else
    for d in "$@"; do
        bash $0 $d
    done
    exit 0
fi

pwd
