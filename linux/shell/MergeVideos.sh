#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

# base=$(date +%FT%H-%M-%S.%N)
xx=$(tr -dc '0-9a-zA-Z' < /dev/random  | fold -w 8 | head -n 1 || true)
base=$(date +%FT%H-%M-%S).$xx

n=0
for v in $*; do
    n=$((n+1))
    if [[ "$v" != "*.mp4" && "$v" != "*.MP4" ]]; then
        out=$xx.$(printf '%03d' $n).mp4
        ffmpeg -i $v -movflags use_metadata_tags $out
    else
        out=$v
    fi
    echo "file $out"
done > $base.list

ffmpeg -f concat -i $base.list -c copy $base.mp4

awk '{print $2}' $base.list | xargs -i rm {}
echo "==> save $base.mp4"
