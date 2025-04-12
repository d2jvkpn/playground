#!/usr/bin/env bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

url=$1
retries=${2:-15}; curl_args=${curl_args:-""}

echo "==> $(date +%FT%T%:z) http_check start: retries=$retries, curl_args=\"$curl_args\""

n=1 # --connect-timeout
while [[ $(2>&1 curl -s -I --max-time 3 $url $curl_args | awk 'NR==1{print $2; exit}') != "200" ]];
    do
    sleep 1; echo -n "."

    n=$((n+1)); [ $((n%60)) -eq 0 ] && echo ""

    [[ $retries -gt 0 && $n -gt $retries ]] && { >&2 echo 'http_check abort!!!'; exit 1; }
done
echo ""

echo "==> $(date +%FT%T%:z) http_check exit: ok"
