#!/bin/bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

input_video=${input_video:=""}
fps=${fps:-4}

if [ ! -z "$input_video" ]; then
    mkdir -p images && rm -f images/*

    ffmpeg -i $input_video -vf fps=$fps images/%06d.png
    echo "==> image number: $(ls images/* | wc -l)"
fi

mkdir -p distorted

{
    date +'==> %FT%T%:z colmap start'

    if [ $(command -v xvfb-run) ]; then
        run="xvfb-run"
    else
        $run=""
    fi

    $run colmap automatic_reconstructor --image_path ./images --workspace_path ./distorted

    date +'==> %FT%T%:z colmap end'
} &> colmap.log

exit

ffmpeg -i input.webm  -vf "format=yuv444p,scale=1200x790"  -c:a copy output.mp4
