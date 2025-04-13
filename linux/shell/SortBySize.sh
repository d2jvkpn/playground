#!/usr/bin/env bash
set -eu -o pipefail; _wd=$(pwd); _path=$(readlink -f `dirname "$0"`)

asc=${asc:-"false"}

if [[ "$asc" == "true" ]]; then
    du -sh -- *  | sort -h
else
    du -sh -- *  | sort -rh
fi

exit
du -sk -- * | sort -nr | awk -F '\t' '{print "\""$2"\""}' | xargs du -sh
