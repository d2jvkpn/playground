#!/usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})


function my_func() {
    sleep 1.42

    ans=$((RANDOM%4)) || return 1
    >&2 echo "==> $(date +%FT%T%:z) ans: $ans" || return 1

    return $ans # 0, 1, 2, 3
}

n=1
while ! my_func; do
    >&2 echo "...try again: my_func"

    n=$((n+1))
    [ $n -gt 10 ] && { >&2 echo '!!! my_func failed'; exit 1; }
    sleep 1
done
