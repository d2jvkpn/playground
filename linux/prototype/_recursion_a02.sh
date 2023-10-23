#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})


case $# in
0)
    # >&2 echo "arg(s) not provided!"
    # exit 1
    arg=0.42
    ;;
1)
    arg=$1
    ;;
*)
    for arg in "$@"; do bash "$0" "$arg"; done
    exit 0
esac

>&2 echo "==> [$(date +%FT%T.%N%:z)] arg: $arg"

sleep $arg

#### more codes...
exit 0

Hello, world!
