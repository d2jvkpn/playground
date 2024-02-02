#! /usr/bin/env bash
set -eu -o pipefail
# set -x
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

cmd="$*"

sleep_secs=${slee_secs:-1}; retries=${retries:-15}

n=1
while ! $cmd; do
    sleep $sleep_secs
    n=$((n+1))

    [ $n -gt $retries ] && { >&2 echo '!!!' "$(date +%FT%T%:z) abort"; exit 1; }

    >&2 echo "--> $(date +%FT%T%:z) try again: $n/$retries"
done
