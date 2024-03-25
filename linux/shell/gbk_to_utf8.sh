#! /usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

input=$1
output=$2

iconv -f gbk -t utf-8 $input -o $output
