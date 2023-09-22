#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

####
sep=","
prefix=node-
echo $prefix$(seq -s ${sep}${prefix} 1 5)

####
for i in {1..5}; do
    echo -n $i@kafka-node$i,
done | sed 's/,$/\n/'
