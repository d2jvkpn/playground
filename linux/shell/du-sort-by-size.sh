#! /usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})


du -sh -- *  | sort -rh

exit

du -sk -- * | sort -nr | awk -F '\t' '{print "\""$2"\""}' | xargs du -sh
