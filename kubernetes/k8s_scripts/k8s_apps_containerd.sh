#! /usr/bin/env bash
set -eu -o pipefail

_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})
# set -x

export DEBIAN_FRONTEND=noninteractive

#### 1.
function apt_install() {
    apt update
    apt -y upgrade
    apt install -y containerd runc

    return 0
}

n=1
while ! apt_install; do
    echo "...try again: apt_install"
    n=$((n+1))
    [ $n -gt 5 ] && { >&2 echo "apt_install failed"; exit 1; }
    sleep 1.42
done

containerd config default | grep SystemdCgroup
containerd config default | grep sandbox_image

#### 2.
mkdir -p /etc/containerd

pause=$(kubeadm config images list | awk '/pause/{sub(".*/", ""); print}')

# containerd config default | sed '/SystemdCgroup/{s/false/true/}'   |
#   awk -v pause=$pause '/k8s.gcr.io\/pause/{sub("k8s.gcr.io/pause.*", pause"\"")} {print}' \
#   > /etc/containerd/config.toml

containerd config default | sed '/SystemdCgroup/{s/false/true/}'  |
  awk -v pause=$pause '/sandbox_image/{sub("pause:[0-9.]*", pause)} {print}' |
  sudo tee /etc/containerd/config.toml

# grep pause: /etc/containerd/config.toml

systemctl restart containerd
systemctl status containerd
# journalctl -fexu containerd

#### 3.
cat <<EOF | sudo tee /etc/crictl.yaml
runtime-endpoint: unix:///run/containerd/containerd.sock
image-endpoint: unix:///run/containerd/containerd.sock
timeout: 5
debug: false
pull-image-on-create: false
EOF
