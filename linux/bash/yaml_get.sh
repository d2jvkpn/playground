#!/usr/bin/env bash
set -eu -o pipefail; _wd=$(pwd); _path=$(readlink -f `dirname $0`)

yaml=$1
field=$2

awk -v k="$field" '$0 ~ "^"k": " {print $2; exit}' $yaml
