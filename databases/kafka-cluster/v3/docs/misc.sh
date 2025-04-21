#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(readlink -f `dirname "$0"`)

####
sep=","
prefix=node-
echo $prefix$(seq -s ${sep}${prefix} 1 5)

####
for i in {1..5}; do
    echo -n $i@kafka-node$i,
done | sed 's/,$/\n/'
