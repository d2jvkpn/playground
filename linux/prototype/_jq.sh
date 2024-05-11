#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

# json fields to tsv

cat nginx.log |
  jq -r '[.time, .remote_addr] | @tsv'|
  awk -F "[T\t]" '{print $1"\t"$NF}' |
  sort | uniq -c
