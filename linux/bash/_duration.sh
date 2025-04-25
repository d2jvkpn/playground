#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


[ $# -eq 0 ] &&  { >&2 echo "no arg(s) provided"; exit 1; }

t0=$(date +%s.%N)

eval "$@"

t1=$(date +%s.%N)

seconds=$((${t1%\.*} - ${t0%\.*}))
ns=$((${t1#*\.} - ${t0#*\.}))

>&2 printf "==> %dm%d.%09ds elapsed\n" $((seconds/60)) $((seconds%60)) ${ns}
