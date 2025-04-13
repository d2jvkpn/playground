#!/usr/bin/env bash
set -eu -o pipefail; _wd=$(pwd); _path=$(readlink -f `dirname "$0"`)

pn="$1"

pids=$(ps -ef | grep -w $pn | grep -v "grep" | awk '{print $2}')

test -z "$pids" && { >&2 echo "prcess not found"; exit; }

for p in $pids; do
  echo ">>> $p, $(ps -p $p -o user,lstart | sed '1d'), $(pwdx $p | awk '{print $2}'), \
$(lsof -p $p | wc -l)"
done
