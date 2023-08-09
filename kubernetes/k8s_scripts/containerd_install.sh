#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

export DEBIAN_FRONTEND=noninteractive

#### 1.
apt update
apt -y upgrade
apt install -y containerd runc

containerd config default | grep SystemdCgroup
containerd config default | grep sandbox_image

#### 2.
sudo mkdir -p /etc/containerd

pause=$(kubeadm config images list | grep pause)

# containerd config default | sed '/SystemdCgroup/{s/false/true/}'   |
#   awk -v pause=$pause '/k8s.gcr.io\/pause/{sub("k8s.gcr.io/pause.*", pause"\"")} {print}' \
#   > /etc/containerd/config.toml

containerd config default | sed '/SystemdCgroup/{s/false/true/}'  |
  awk -v pause=$pause '/registry.k8s.io\/pause/{sub("registry.k8s.io/pause.*", pause"\"")} {print}' |
  sudo tee /etc/containerd/config.toml

# grep pause: /etc/containerd/config.toml

sudo systemctl restart containerd
sudo systemctl status containerd

#### 3.
cat <<EOF | sudo tee /etc/crictl.yaml
runtime-endpoint: unix:///run/containerd/containerd.sock
image-endpoint: unix:///run/containerd/containerd.sock
timeout: 5
debug: false
pull-image-on-create: false
EOF
