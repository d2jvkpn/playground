#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


video=$1

length=$(ffprobe -v error -show_entries format=duration -of default=nw=1:nk=1 "$video")

ffmpeg -ss $length -i "$video" -frames:v 1 -q:v 2 "$video.last_frame.jpg"

exit
ffmpeg -i "$video" -vf "reverse" -frames:v 1 -q:v 2 "$video.last_frame.jpg"
