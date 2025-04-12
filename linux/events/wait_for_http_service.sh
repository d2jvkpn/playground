#!/usr/bin/env bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

# addr=http://127.0.0.1:7860
addr=$1

retries=${retries:-15}
echo "==> Waiting service $addr to launch..."

n=1
while ! curl --output /dev/null --silent --head --fail $addr; do
    sleep 1 && echo -n .

    n=$((n+1)); [ $((n % 60 )) == 0 ] && echo ""
    [[ $retries -gt 0 && $n -gt "$retries" ]] && { >&2 echo '!!! abort'; exit 1; }
done
echo ""

echo "==> Service $addr is ok"
