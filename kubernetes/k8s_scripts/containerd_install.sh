#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

export DEBIAN_FRONTEND=noninteractive

####
apt update
apt -y upgrade
apt install -y containerd runc

containerd config default | grep SystemdCgroup
containerd config default | grep sandbox_image

####
pause=$(kubeadm config images list | grep pause)
sudo mkdir -p /etc/containerd

containerd config default | sed '/SystemdCgroup/{s/false/true/}'   |
  awk -v pause=$pause '/k8s.gcr.io\/pause/{sub("k8s.gcr.io/pause.*", pause"\"")} {print}' \
  > /etc/containerd/config.toml

# grep pause: /etc/containerd/config.toml

systemctl restart containerd
systemctl status containerd

####
cat > /etc/crictl.yaml <<EOF
runtime-endpoint: unix:///run/containerd/containerd.sock
image-endpoint: unix:///run/containerd/containerd.sock
timeout: 5
debug: false
pull-image-on-create: false
EOF
