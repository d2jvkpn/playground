#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

mkdir -p images && rm -f images/*

ffmpeg -i input.mp4 -vf fps=4 images/%06d.png
echo "==> image number: $(ls images/* | wc -l)"

mkdir -p distorted

{
    date +'==> %FT%T%:z colmap start'
    xvfb-run colmap automatic_reconstructor --image_path ./images --workspace_path ./distorted
    date +'==> %FT%T%:z colmap end'
} &> colmap.log
