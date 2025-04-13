#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(readlink -f `dirname "$0"`)

levels=${1:-0}; suffix=${2:-mp4}
path=""; play=${play:-"false"}

for i in $(seq 1 $levels); do
    path="*/"$path
done

>&2 echo "==> targets: ${path}*.${suffix}"

ls -1 ${path}*.${suffix} > playlist.m3u

[[ "$play" == "true" ]] && mpv playlist.m3u
