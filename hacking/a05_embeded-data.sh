#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


function extract_embeded() {
    key=$1
    sed -n "/^__START_${key}__$/,/^__END_${key}__/p" "$0" | tail -n +2 | head -n -1
}


echo "==> Extract embeded: key=Data"
extract_embeded Data
# ....

exit 0

__START_Config__
civilization:
  location: earth
  year: 2025
  speices: Homo sapiens
__END_Config__


__START_Data__
embbed data line 1
embbed data line 2
embbed data line 3
__END_Data__
