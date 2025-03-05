#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

#### install nfs server
sudo apt update
sudo apt install nfs-kernel-server
# sudo yum install nfs-utils  # CentOS/RHEL

sudo systemctl enable nfs-kernel-server
sudo systemctl start nfs-kernel-server
#sudo systemctl enable nfs-server # CentOS/RHEL
#sudo systemctl start nfs-server    # CentOS/RHEL

#### create nfs server
sudo mkdir -p /var/nfs_share

sudo chown nobody:nogroup /var/nfs_share    # Ubuntu/Debian
# sudo chown nobody:nobody /var/nfs_share   # CentOS/RHEL
sudo chmod 777 /var/nfs_share

echo "/var/nfs_share 192.168.1.0/24(rw,sync,no_subtree_check,no_root_squash)" | sudo tee /etc/exports
#/var/nfs_share: 共享目录。
#192.168.1.0/24: 允许访问的客户端 IP 范围（可以根据需要调整）。
#rw: 允许读写权限。
#sync: 同步写入，确保数据一致性。
#no_subtree_check: 禁用子树检查，提高性能。
#no_root_squash: 允许客户端 root 用户保留权限（谨慎使用）。

sudo exportfs -a
sudo systemctl restart nfs-kernel-server

sudo ufw allow from 192.168.1.0/24 to any port nfs
#sudo firewall-cmd --permanent --add-service=nfs   # CentOS/RHEL
#sudo firewall-cmd --permanent --add-service=mountd
#sudo firewall-cmd --permanent --add-service=rpc-bind
#sudo firewall-cmd --reload

#### install nfs client
sudo apt-get update
sudo apt-get -y install nfs-common
# sudo yum install nfs-utils

#### nfs mount
sudo mkdir -p /mnt/nfs

sudo mount -t nfs 192.168.1.100:/var/nfs_share /mnt/nfs
# df -h | grep nfs

sudo echo "192.168.1.100:/export/shared /mnt/nfs nfs defaults 0 0" | sudo tee -a /etc/fstab
sudo mount -a
