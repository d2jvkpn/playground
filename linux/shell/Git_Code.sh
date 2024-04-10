#! /usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

if [ $# -gt 0 ]; then
    git clone $1 code
    exit 0
fi

if [ ! -d code && ! -s code.zip ]; then
    >&2 echo "==> Not code(.zip) found!"
    exit 1
elif [ ! -d code && -s code.zip ]; then
    unzip code.zip
fi

cd code
output=$(git pull --no-edit)

if [[ "$output" =~ "Already up-to-date." ]]; then
    echo "==> Code is already up-to-date"
    exit 0
fi

cd ${_path}

echo "==> Replacing code.zip"
[ -f code.zip ] && rm code.zip

zip -r code.zip code
