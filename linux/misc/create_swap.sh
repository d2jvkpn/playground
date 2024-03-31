#!/usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

swap_gb=$(awk '$1=="MemTotal:"{print $2/2/1024/1024; exit}' /proc/meminfo)
swap_gb=${1:-$swap_gb}

sudo swapoff --all

sudo fallocate -l ${swap_gb}G /swap.img
# dd if=/dev/zero of=/swap.img bs=1G count=8
sudo chmod 600 /swap.img

sudo mkswap /swap.img
# UUID=7929e1f6-1647-4dba-bc3f-e5ab1b9a530b
sudo cp /etc/fstab /etc/fstab.bk
echo -e "\n#### swap\n/swap.img  none  swap  sw  0  0" | sudo tee -a /etc/fstab

cat /proc/sys/vm/swappiness # 60
# setup temporary
# sudo sysctl vm.swappiness=50
echo 50 | sudo tee /proc/sys/vm/swappiness

sudo swapon --all
