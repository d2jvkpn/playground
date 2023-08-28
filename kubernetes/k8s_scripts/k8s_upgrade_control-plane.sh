#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

# version=1.28.1; node=cp01
version=$1; node=$2

#### 
apt-get update
# apt-cache madison kubeadm | head || true
apt-mark unhold kubeadm
apt-get install -y kubeadm=${version}-00
apt-mark hold kubeadm
# kubeadm version

kubeadm upgrade plan
kubeadm upgrade diff $version

# kubectl -n kube-system get cm kubeadm-config -o yaml
# kubeadm upgrade apply v$version
kubeadm upgrade node
# ....
# kubectl get pod -o wide | grep $node
# kubectl -n kube-system get cm kubeadm-config -o yaml
# kubectl get node -o wide

####
apt-mark unhold kubelet kubectl
apt-get install -y kubelet=${version}-00 kubectl=${version}-00
apt-mark hold kubelet kubectl

systemctl daemon-reload
systemctl restart kubelet