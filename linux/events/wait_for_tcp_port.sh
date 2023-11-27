#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

host=$1; port=$2
timeout_secs=${3:-300}

echo "==> Waiting for TCP $host:$port to open..."

n=0
while ! nc -z $host $port; do
    # wait for 0.1(1/10) of the second before check again
    sleep 1 && echo -n .
    n=$((n+1))
    [ $((n % 60 )) == 0 ] && echo ""

    if [[ "$timeout_secs" -gt 0 && $n -ge "$timeout_secs" ]]; then
        echo ""
        echo "==> Timeout" >&2
        exit 1
    fi
done
echo ""

echo "==> TCP $host:$port is open"
