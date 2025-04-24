#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


a="unknown"

function remove_item() {
    echo "==> remove item: $a, $1"
}

#trap 'remove_item on_error' ERR # will be executed before EXIT
trap 'echo No No No' ERR
trap 'remove_item on_exit' EXIT

echo "==> Hello, world!"

ls not_exists
