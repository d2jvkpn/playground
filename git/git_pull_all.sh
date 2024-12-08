#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})


cd ${_path}

for d in $(find -type d -name ".git"); do
    cd $d
    cd ../
    echo "==> $(pwd)"
    git pull
    cd ${_wd}
done
