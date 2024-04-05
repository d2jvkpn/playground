#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

timestamp=${timestamp:-$(date +%Y%m%d%H%M.%S)}

function change_file_timestamp() {
    target=$1; stamp=$2
    echo "==> change_file_timestamp: file=$target, timestamp=$timestamp"

    if [ -d "$target" ]; then
        find "$target" -name "*" | xargs -i touch -a -m -t "$timestamp" {}
    else
        touch -a -m -t "$timestamp" "$target"
    fi
}

for target in "$@"; do
    change_file_timestamp "$target" "$timestamp"
done
