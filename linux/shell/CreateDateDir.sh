#! /usr/bin/env bash
set -eu -o pipefail
# set -x
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})


prefix=${1:-""}
clock=${clock:-0}

if [ "${clock}" == "1" ]; then
    outdir=$(date +%FT%H-%M-%S)
elif [ "${clock}" == "2" ]; then
    outdir=$(date +%FT%H-%M-%S-%s)
else
    outdir=$(date +%F)
fi

outdir=${prefix}${outdir}
mkdir -p $outdir

>&2 echo "~~~ created directory: $outdir"
