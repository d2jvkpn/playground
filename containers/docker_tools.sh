#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

exit
docker build --network=host -f Containerfile -t name:tag ./


#### install on centos
# https://docs.docker.com/engine/install/centos/
# echo "Hello, world!"

yum install -y yum-utils device-mapper-persistent-data lvm2

yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo ||
  yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

systemctl start docker
systemctl enable docker


#### podman
sudo apt install podman qemu-utils

podman machine init
# quay.io/podman/machine-os:5.3

pod machine start

pip3 install podman-compose


exit
podman generate systemd --name mycontainer

sudo cp container-mycontainer.service /etc/systemd/system/

sudo systemctl enable container-mycontainer.service
sudo systemctl start container-mycontainer.service


exit
sudo apt insall podman podman-compose buildah
