#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

# echo "Hello, world!"

docker run --rm -it caddy:2-alpine caddy hash-password

exit
openssl passwd -6
