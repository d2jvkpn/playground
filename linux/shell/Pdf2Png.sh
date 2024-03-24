#! /usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

for pdf in $@; do
    echo "Convert $pdf"
    png=${pdf%.pdf}.png

    if  [ ! -s "$pdf" ]; then
        echo "    $pdf, file not exists, skip"
        exit 1
    fi

    if [[ "$png" == "$pdf" ]]; then
        echo "    $pdf, convert is trying to overwritten itself, skip"
        exit 1
    fi

    gs -q -o $png -sDEVICE=pngalpha -dLastPage=1 -r144 $pdf 2
done

exit

pdftoppm title.pdf title -png
