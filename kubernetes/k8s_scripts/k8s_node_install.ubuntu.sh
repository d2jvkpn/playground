#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

export DEBIAN_FRONTEND=noninteractive

#### 1. set k8s repository
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
# version=1.31.2
# key_url=https://pkgs.k8s.io/core:/stable:/v1.31/deb
# version=$(yq .k8s.version k8s.local/k8s_download.yaml)

version=$1 # 1.32.0
ver=v${version%.*} # v1.32
key_url=https://pkgs.k8s.io/core:/stable:/$ver/deb
key_file=/etc/apt/keyrings/k8s.$ver.gpg

[ ! -s $key_file ] && {
  curl -fsSL $key_url/Release.key | sudo gpg --dearmor -o $key_file;
}

echo "deb [signed-by=$key_file] $key_url /" |
  sudo tee /etc/apt/sources.list.d/k8s.$ver.list > /dev/null

#### 2. apt install
function apt_install() {
    apt-get update || return 1
    apt-get -y upgrade || return 1

    apt-get -y install apt-transport-https ca-certificates \
      lsb-release gnupg pigz curl jq \
      socat conntrack dnsutils nfs-kernel-server nfs-common nftables \
      etcd-client containerd runc || return 1

    # apt-mark unhold kubelet kubeadm kubectl
    apt-get install -y kubectl kubelet kubeadm || return 1
    apt-mark hold kubelet kubeadm kubectl || return 1

    return 0
}

n=1
while ! apt_install; do
    >&2 echo "... try_again: apt install"
    sleep 1.42

    n=$((n+1))
    [ $n -gt 5 ] && { >&2 echo '!!!' "operation_failed: apt install"; exit 1; }
done

apt clean && apt autoclean
apt remove && apt autoremove
dpkg -l | awk '/^rc/{print $2}' | xargs -i dpkg -P {}

# systemctl disable kubelet

kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl > /dev/null
# kubeadm config images list

# cp /etc/systemd/system/kubelet.service.d/10-kubeadm.conf \
#   /etc/systemd/system/kubelet.service.d/10-kubeadm.conf.bk

# sed -i '/$KUBELET_EXTRA_ARGS/s/$/ --fail-swap-on=false/' \
#   /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

systemctl daemon-reload
systemctl enable kubelet.service
systemctl status kubelet.service || true
#!! kubelet.server will started by kubeadm init

#### 3. k8s config
cat <<EOF | sudo tee /etc/modules-load.d/kubernetes.conf > /dev/null
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

lsmod | grep overlay
lsmod | grep br_netfilter

# cat /proc/sys/fs/inotify/max_user_watches
# echo fs.inotify.max_user_watches=524288 | sudo tee /etc/sysctl.d/50_max_user_watches.conf > /dev/null

cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf > /dev/null
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1

net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.all.promote_secondaries = 1
EOF
# sysctl: setting key "net.ipv4.conf.all.accept_source_route": Invalid argument
# sysctl: setting key "net.ipv4.conf.all.promote_secondaries": Invalid argument

sysctl --system
# temporary
# sudo sysctl -w net.ipv6.conf.default.forwarding=1


#### 4. containerd
containerd config default | grep SystemdCgroup
containerd config default | grep sandbox_image

mkdir -p /etc/containerd
pause=$(kubeadm config images list | awk '/pause/{sub(".*/", ""); print}')

# containerd config default | sed '/SystemdCgroup/{s/false/true/}'   |
#   awk -v pause=$pause '/k8s.gcr.io\/pause/{sub("k8s.gcr.io/pause.*", pause"\"")} {print}' \
#   > /etc/containerd/config.toml

containerd config default | sed '/SystemdCgroup/{s/false/true/}' |
  awk -v pause=$pause '/sandbox_image/{sub("pause:[0-9.]*", pause)} {print}' |
  sudo tee /etc/containerd/config.toml > /dev/null

# grep pause: /etc/containerd/config.toml

cat <<EOF | sudo tee /etc/crictl.yaml > /dev/null
runtime-endpoint: unix:///run/containerd/containerd.sock
image-endpoint: unix:///run/containerd/containerd.sock
timeout: 5
debug: false
pull-image-on-create: false
EOF

#### 5. deleted pods stuck in "Terminating" on LAB K8s v1.30 on Ubuntu 24.04 [workaround]
# https://forum.linuxfoundation.org/discussion/866759/deleted-pods-stuck-in-terminating-on-lab-k8s-v1-30-on-ubuntu-24-04-workaround
# https://github.com/containrrr/watchtower/issues/1891

mkdir -p /etc/apparmor.d/disable
ln -s /etc/apparmor.d/runc /etc/apparmor.d/disable/
apparmor_parser -R /etc/apparmor.d/runc
systemctl restart containerd

#### 6. restart containerd
systemctl restart containerd
# systemctl status containerd
# journalctl -fexu containerd
