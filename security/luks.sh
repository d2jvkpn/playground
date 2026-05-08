#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


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
