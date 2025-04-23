#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


filepath=${2:-$0}
function extract_embeded() {
    key=$1
    sed -n "/^__$key-0__$/,/^__$key-1__/p" "$filepath" | tail -n +2 | head -n -1
}

# ....

key=${1:-DATA}

echo "==> Extract embeded from $filepath: key=$key"
extract_embeded $key

exit 0

__DATA-0__
embbed data line 1
embbed data line 2
embbed data line 3
__DATA-1__
