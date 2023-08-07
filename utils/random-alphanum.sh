#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

width=$1; count=${2:-1}

cat /dev/urandom |
  tr -dc 'a-zA-Z0-9' |
  fold -w ${1:-$width} |
  head -n $count
