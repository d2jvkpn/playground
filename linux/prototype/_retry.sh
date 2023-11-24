#! /usr/bin/env bash
set -eu -o pipefail

_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})
# set -x

function my_func() {
    sleep 1.42

    ans=$((RANDOM%2))
    >&2 echo "==> $(date +%FT%T%:z) ans: $ans"

    return $ans
}

n=1
while ! my_func; do
    echo "...try again: my_func"
    n=$((n+1))
    if [ $n -gt 5 ]; then >&2 echo '!!! my_func failed'; exit 1; fi
done
