#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

asc=${asc:-"false"}

if [[ "$asc" == "true" ]]; then
    du -sh -- *  | sort -h
else
    du -sh -- *  | sort -rh
fi

exit
du -sk -- * | sort -nr | awk -F '\t' '{print "\""$2"\""}' | xargs du -sh
