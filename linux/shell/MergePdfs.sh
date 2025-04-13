#!/usr/bin/env bash
set -eu -o pipefail; _wd=$(pwd); _path=$(readlink -f `dirname "$0"`)

output=$1
shift
list=$@

gs -q -sPAPERSIZE=letter -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile="$output" "$@"
