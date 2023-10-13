#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

a="unknown"

function remove_item() {
    echo "==> remove item: $a"
}

trap 'remove_item' ERR

echo "==> Hello, world!"

ls not_exists
