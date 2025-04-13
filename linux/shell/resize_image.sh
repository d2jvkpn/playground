#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(readlink -f `dirname "$0"`)

# with the help of ChatGPT

longest_edge=${longest_edge:-1980}

if [ $# -eq 0 ]; then
    >&2 echo -e "Usage:\n    longest_edge=1980 bash resize_image.sh img01.jpeg img02.jpeg"
    exit 0
elif [ $# -eq 1 ]; then
    :
else
    for a in "$@"; do
        bash "$0" "$a"
    done
    exit 0
fi

image_path="$1"

# 获取图片的宽度和高度
dimensions=$(identify -format "%w %h" "$image_path")
width=$(echo $dimensions | cut -d ' ' -f 1)
height=$(echo $dimensions | cut -d ' ' -f 2)

# 确定缩放比例
if [ "$width" -gt "$height" ]; then
    # 横向图片
    resize_dimension="${longest_edge}x"  # 固定宽度
else
    # 纵向图片
    resize_dimension="x${longest_edge}"  # 固定高度
fi

base=${image_path%.*}
ext=${image_path##*.}
output="${base}.resized.${ext}"

>&2 echo "==> longest_edge=$longest_edge, output=$output"

# 进行尺寸调整
convert "$image_path" -resize "$resize_dimension" "$output"

>&2 echo "==> image has been resized and saved as $output"
