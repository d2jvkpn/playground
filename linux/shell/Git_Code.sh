#!/bin/bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname "$0" | xargs -i readlink -f {})

if [ $# -gt 0 ]; then
    git clone $1 code
    zip -qr code.zip code
    exit 0
fi

if [[ ! -d code && ! -s code.zip ]]; then
    >&2 echo "==> not code(.zip) found!"
    exit 1
elif [[ ! -d code && -s code.zip ]]; then
    unzip -q code.zip
fi

cd code
echo "==> git pull"
output=$(git pull --no-edit)

if [[ "$output" =~ "Already up-to-date." ]]; then
    echo "==> code is already up-to-date"
    exit 0
fi

cd "${_path}"

echo "==> replacing code.zip"
[ -f code.zip ] && rm code.zip
zip -qr code.zip . -i code
