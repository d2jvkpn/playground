#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


remote_host=$1
image=$2
tag=$3

basename=$(echo "${image}--${tag}" | sed 's#/#--#g')

echo "==> Downloading to $basename.tar.gz"
ssh $remote_host docker save $image:$tag | pigz > $basename.tar.gz

echo "<== Done"
