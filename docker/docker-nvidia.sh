#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

# https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/nvidia-docker.html

distribution=$(. /etc/os-release; echo $ID$VERSION_ID)

curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey |
  sudo gpg --dearmor -o /etc/apt/keyrings/nvidia-container-toolkit.gpg
# /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg

curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list |
  sed 's#deb https://#deb [signed-by=/etc/apt/keyrings/nvidia-container-toolkit.gpg] https://#g' |
  sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

sudo apt update
sudo apt-get install -y nvidia-container-toolkit

sudo nvidia-ctk runtime configure --runtime=docker
 
sudo systemctl restart docker

docker run --rm --runtime=nvidia --gpus all nvidia/cuda:11.6.2-base-ubuntu20.04 nvidia-smi

exit

jq  '. + { experimental: true }' /etc/docker/daemon.json > daemon.json
cp /etc/docker/daemon.json /etc/docker/daemon.json.bk
mv daemon.json /etc/docker/daemon.json
systemctl restart docker
