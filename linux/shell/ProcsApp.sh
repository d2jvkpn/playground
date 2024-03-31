#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

pn="$1"

pids=$(ps -ef | grep -w $pn | grep -v "grep" | awk '{print $2}')

test -z "$pids" && { >&2 echo "prcess not found"; exit; }

for p in $pids; do
  echo ">>> $p, $(ps -p $p -o user,lstart | sed '1d'), $(pwdx $p | awk '{print $2}'), \
$(lsof -p $p | wc -l)"
done
