#! /usr/bin/env bash
set -eu -o pipefail

_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})
# set -x

t0=$(date +%s.%N)

# TODO:
echo "==> sleep"
sleep 10

t1=$(date +%s.%N)

seconds=$((${t1%\.*} - ${t0%\.*}))
ns=$((${t1#*\.} - ${t0#*\.}))

>&2 printf "==> %dm%d.%09ds elapsed\n" $((seconds/60)) $((seconds%60)) ${ns}

exit
printf '%-5s' "abc"
