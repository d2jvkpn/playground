#! /usr/bin/env bash
set -eu -o pipefail
# set -x
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})


if [ "${clock:-"false"}" == "true" ]; then
    outdir=$(date +%FT%H-%M-%S)
else
    outdir=$(date +%F)
fi

mkdir -p $outdir

>&2 echo "~~~ created directory: $outdir"
