#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


mkdir -p data


# 如果要视频+麦克风：加上 -f alsa -i default（Linux）
ffmpeg \
 -f v4l2 -framerate 30 -video_size 1280x720 -i /dev/video0 \
 -f alsa -i default \
 -vcodec libx264 -preset veryfast -tune zerolatency -pix_fmt yuv420p \
 -acodec aac -ar 48000 -b:a 128k \
 -f hls -hls_time 1 -hls_list_size 6 -hls_flags delete_segments+append_list+independent_segments \
 -master_pl_name data/master.m3u8 -hls_segment_filename data/stream_%03d.ts data/stream.m3u8
