#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

#### ffmepeg-cut-video
input=$1
start=$2    # 00:13:48
duration=$3 # 00:04:18
output=$4

ffmpeg -i $input -ss $start -t $duration -acodec copy -vcodec copy $output

####
mp4=$1
ffmpeg -i "$mp4" -vn -ar 44100 -ac 2 -ab 192k -f mp3 "${mp4%.mp4}.mp3"
