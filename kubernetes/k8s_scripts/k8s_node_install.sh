#! /usr/bin/env bash
set -eu -o pipefail

_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})
# set -x

export DEBIAN_FRONTEND=noninteractive

# version=$(yq .version k8s_apps/k8s.yaml)
version=$1
region=${region:-unknown}

# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

#### 1. set k8s repository
# key_url=https://pkgs.k8s.io/core:/stable:/v1.28/deb
ver=v${version%.*}

key_url=https://pkgs.k8s.io/core:/stable:/$ver/deb
key_file=/etc/apt/keyrings/kubernetes.$ver.gpg

[ ! -f $key_file ] && curl -fsSL $key_url/Release.key | sudo gpg --dearmor -o $key_file
echo "deb [signed-by=$key_file] $key_url /" | sudo tee /etc/apt/sources.list.d/kubernetes.$ver.list

#### 2. apt install
function apt_install() {
    apt-get update
    apt-get -y upgrade

    apt-get -y install apt-transport-https ca-certificates lsb-release gnupg pigz curl jq \
      socat conntrack nfs-kernel-server nfs-common nftables etcd-client

    # apt-mark unhold kubelet kubeadm kubectl
    apt-get install -y kubectl kubelet kubeadm
    apt-mark hold kubelet kubeadm kubectl

    return 0
}

n=1
while ! apt_install; do
    >&2 echo "...try again: apt_install"

    n=$((n+1))
    [ $n -gt 5 ] && { >&2 echo "apt_install failed"; exit 1; }
    sleep 1.42
done

# systemctl disable kubelet

kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl
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
cat <<EOF | sudo tee /etc/modules-load.d/kubernetes.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

lsmod | grep overlay
lsmod | grep br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1

net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.all.promote_secondaries = 1
EOF

sysctl --system
