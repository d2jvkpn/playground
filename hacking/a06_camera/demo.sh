#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit
mkdir -p data

# 1. open a camera
ffplay /dev/video0

# 2. take a photo
ffmpeg -f v4l2 -i /dev/video0 -frames:v 1 data/camera.$(date +%F-%s).jpg

# 3. record a video
ffmpeg -f v4l2 -i /dev/video0 -t 10 data/camera.$(date +%F-%s).mp4
ffmpeg -f avfoundation -i "0" -t 10 data/camera.$(date +%F-%s).mp4

ffmpeg -f v4l2 -framerate 30 -video_size 1280x720 -i /dev/video0 \
       -c:v libx264 -preset ultrafast -t 30 data/camera.$(date +%F-%s).mp4

# -vf "drawtext=text='%{localtime\:%Y-%m-%dT%H\\\\\:%M\\\\\:%S}':fontcolor=blue:fontsize=30:x=50:y=50" \

ffmpeg -f v4l2 -framerate 30 -video_size 1280x720 -i /dev/video0 \
  -vf "drawtext=text='%{localtime\:%Y%m%d_%H%M%S_%s}':fontcolor=blue:fontsize=30:x=50:y=50" \
  -c:v libx264 -preset ultrafast -t 30 \
  data/camera.$(date +%F-%s).mp4
