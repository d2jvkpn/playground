#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

# base=IMG_2486
# [ $# -gt 0 ] && base=$1
base=$1
base=${base%\.MOV}

#### show meta info
# ffprobe -show_data -hide_banner $base.MOV

dt=$(
  ffprobe -show_data -hide_banner $base.MOV 2>&1 |
  awk '/creationdate/{dt=substr($2, 0, 19); gsub(":", "-", dt); print dt; exit}'
)

# echo $dt

#### convert mov to mp4
if [[ "$base" =~ IMG_[0-9]+ ]]; then
    ffmpeg -i $base.MOV -movflags use_metadata_tags $dt.tmp.mp4
    mv $dt.tmp.mp4 $dt.mp4
else
    ffmpeg -i $base.MOV -movflags use_metadata_tags $base.tmp.mp4
    mv $base.tmp.mp4 $base.mp4
fi

# ffprobe -show_data -hide_banner $base.mp4
