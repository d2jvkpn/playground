#!/usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

len=${1:-32}

tr -dc '0-9a-zA-Z!@#$%^&*()._\-' < /dev/urandom |
  fold -w $len |
  head -n 5 || true

# head -c $len
