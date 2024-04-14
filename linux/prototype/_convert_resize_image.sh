#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

size=${1:-50%}
# percentage: 50%
# fixed height: 2048x
# fixed width: x1024
# fixd width and heightL 2048x1024

#### TODO: find ... | xargs ...
for f in $(find raw -type f -o -name "*.jpg" -o -name "*.png"); do
   convert -resize $size "$f" $(basename "$f")
done
