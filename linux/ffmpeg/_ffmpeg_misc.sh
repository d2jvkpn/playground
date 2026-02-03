#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit
mkdir data

ffmpeg -f lavfi -i color=c=white:size=300x400 data/blank_3-4.png


ffmpeg -y -i ns2.png \
  -vf "scale=720:1280:force_original_aspect_ratio=decrease,pad=720:1280:(ow-iw)/2:(oh-ih)/2" \
  ns2.fixed.png

ffmpeg -y -i ns3.png \
  -vf "scale=720:1280:force_original_aspect_ratio=decrease,pad=720:1280:(ow-iw)/2:(oh-ih)/2" \
  ns3.fixed.png

ffmpeg -y -i f1.png \
  -vf "scale=720:1280:force_original_aspect_ratio=decrease,pad=720:1280:(ow-iw)/2:(oh-ih)/2" \
  f1.fixed.png


#### overlay two video
ffmpeg -i main.mp4 \
  -i lyrics.mp4 \
  -filter_complex "[0:v][1:v]overlay=0:0:format=auto:eof_action=pass[v]" \
  -map "[v]" \
  -map "0:a?" \
  -c:v libx264 \
  -crf 18 \
  -preset medium \
  -c:a copy \
  -movflags "+faststart" \
  overlay.mp4
