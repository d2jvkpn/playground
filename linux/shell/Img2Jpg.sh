#!/usr/bin/env bash
set -eu -o pipefail; _wd=$(pwd); _path=$(readlink -f `dirname "$0"`)

for i in $@; do
    if [ ! -s $i ]; then
        echo "$i: file not exists, skip"
        exit 1
    fi

    jpg=${i%.*}.jpg

    if [[ "$jpg" == "$i" ]]; then
        echo "    $i, convert is trying to overwritten itself, skip"
        exit 1
    fi

    convert -verbose -density 150 -trim  $i -quality 100 \
      -flatten -sharpen 0x1.0 $jpg
done
