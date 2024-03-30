#!/bin/bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

dirs=$(ls -d data/kafka-logs-*/ data/logs-*/ data/zoopkeeper-*/version-2/ || true)

for d in $dirs; do
    [ -d $d ] && rm -rf $d
done
