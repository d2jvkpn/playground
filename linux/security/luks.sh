#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

# lsblk | grep -v "^loop"

device=sdb1
disk=mydisk

command -v cryptsetup || sudo apt-get install cryptsetup

#### enter password
sudo cryptsetup luksOpen /dev/$device $disk

sudo mkdir /mnt/$disk

sudo mount /dev/mapper/$disk /mnt/$disk

exit
sudo umount /mnt/$disk

sudo cryptsetup luksClose $disk
