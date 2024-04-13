#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

levels=${1:-0}; suffix=${2:-mp4}
path=""; play=${play:-"false"}

for i in $(seq 1 $levels); do
    path="*/"$path
done

>&2 echo "==> targets: ${path}*.${suffix}"

ls -1 ${path}*.${suffix} > playlist.m3u

[[ "$play" == "true" ]] && mpv playlist.m3u
