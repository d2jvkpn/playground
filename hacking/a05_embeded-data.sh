#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


function extract_embeded() {
    key=$1
    sed -n "/^__${key}_START__$/,/^__${key}_END__/p" "$0" | tail -n +2 | head -n -1
}

key=${1:-DATA}

echo "==> Extract embeded: key=$key"
extract_embeded $key
# ....

exit 0

__DATA_START__
embbed data line 1
embbed data line 2
embbed data line 3
__DATA_END__
