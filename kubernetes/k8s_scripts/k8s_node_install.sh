#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

# version=1.27.4
version=$1
export DEBIAN_FRONTEND=noninteractive

# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

#### 1. apt install
apt-get update

apt-get -y install apt-transport-https ca-certificates gnupg lsb-release \
  socat conntrack curl jq nfs-kernel-server nfs-common nftables

#### 2. apt k8s
# key_file=/etc/apt/keyrings/kubernetes.gpg

# curl -fsSL https://dl.k8s.io/apt/doc/apt-key.gpg | sudo gpg --dearmor -o $key_file

# echo "deb [signed-by=$key_file] https://apt.kubernetes.io/ kubernetes-xenial main" |
#   sudo tee /etc/apt/sources.list.d/kubernetes.list

#### 2. apt k8s
key_file=/etc/apt/keyrings/kubernetes.gpg
[ -f $key_file ] && rm -f $key_file

curl -fsSL https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg |
  gpg --dearmor -o $key_file

echo "deb [signed-by=$key_file] https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main" |
  sudo tee /etc/apt/sources.list.d/kubernetes.list

apt-get update
# sudo apt-get install -y kubectl kubelet kubeadm
apt install -y kubelet=${version}-00 kubeadm=${version}-00 kubectl=${version}-00

apt-mark hold kubelet kubeadm kubectl
apt-mark unhold kubelet kubeadm kubectl
# systemctl disable kubelet

kubectl completion bash > /etc/bash_completion.d/kubectl
# kubeadm config images list

cp /etc/systemd/system/kubelet.service.d/10-kubeadm.conf \
  /etc/systemd/system/kubelet.service.d/10-kubeadm.conf.bk

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
EOF

sysctl --system
