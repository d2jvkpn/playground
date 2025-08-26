#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


#### 1. format disk
lsblk

fdisk /dev/vdb
# interactive: n

mkfs.ext4 /dev/vdb1

lsblk

#### 2. mount to point
mount_dir=/mnt/vdb1
mkdir -p $mount_dir

sudo mount /dev/vdb1 /mnt/vdb1

#### 3. automount at reboot
blkid | awk '$1=="/dev/vdb1:"'

uuid=xxxxxxxx

sudo cp /etc/fstab /etc/fstab.bk

cat >> /etc/fstab <<EOF
UUID=$uuid $mount_dir ext4 defaults 0 2
EOF

sudo mount -a
