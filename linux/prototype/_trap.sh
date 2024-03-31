#!/usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

a="unknown"

function remove_item() {
    echo "==> remove item: $a, $1"
}

trap 'remove_item on_error' ERR
trap 'remove_item on_exit' EXIT

echo "==> Hello, world!"

ls not_exists
