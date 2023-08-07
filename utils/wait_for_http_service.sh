#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

# addr=http://127.0.0.1:7860
addr=$1

echo "==> Waiting service $addr to launch..."

while ! curl --output /dev/null --silent --head --fail $addr; do
    sleep 1 && echo -n .
done

echo ""
echo "==> Service $addr launched"
