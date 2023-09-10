#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)/
_path=$(dirname $0 | xargs -i readlink -f {})/

sudo fallocate -l 4G /swap
# dd if=/dev/zero of=/swap bs=1G count=4
sudo chmod 600 /swap

sudo mkswap /swap
# UUID=7929e1f6-1647-4dba-bc3f-e5ab1b9a530b
sudo cp /etc/fstab /etc/fstab.bk
echo -e "\n####\n/swap  none  swap  sw  0  0" | sudo tee -a /etc/fstab

swapon --all

cat /proc/sys/vm/swappiness # 60
sudo sysctl vm.swappiness=50

####
exit
swapoff --all
