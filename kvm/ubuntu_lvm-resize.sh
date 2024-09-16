#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

lsblk
pvs
vgdisplay
fdisk -l | grep -- "--lv"

total_size=$(lsblk | awk '/vda3/{sub("G$", "", $4); print $4}')
lv_size=$(lsblk | awk '/ubuntu--vg-ubuntu--lv/{sub("G$", "", $4); print $4}')

[ "$total_size" -gt "$lv_size" ] && {
    size=$((total_size - lv_size))G
    echo "==> lvextend: $size"

    sudo lvextend -L +$size /dev/mapper/ubuntu--vg-ubuntu--lv
    sudo resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv
}
