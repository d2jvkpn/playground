#! /usr/bin/env bash
set -eu -o pipefail
# set -x
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})


outdir=${1:-""}
clock=${clock:-0}

if [ "${clock}" == "1" ]; then
    outdir=${outdir}$(date +%FT%H-%M-%S)
elif [ "${clock}" == "2" ]; then
    outdir=${outdir}$(date +%FT%H-%M-%S-%s)
else
    outdir=${outdir}$(date +%F)
fi

mkdir -p $outdir

>&2 echo "~~~ created dir: $outdir"
