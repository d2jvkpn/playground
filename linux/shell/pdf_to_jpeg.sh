#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

scale=${scale:-2048}
if [ ! -z "scale" ]; then
   args="-scale-to $scale"
else
    args=""
fi

for f in "$@"; do
    pdftoppm -jpeg $args "$f" "$f"
done

exit
pdftoppm -jpeg -r 300 input.pdf output

magick -density 300 input.pdf output.jpg
