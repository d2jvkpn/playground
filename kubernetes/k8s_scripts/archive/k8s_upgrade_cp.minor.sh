#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

#### control-plane
# version=$(yq .version k8s_apps/k8s.yaml)
version=$1 # 1.28.3

ver=v${version%.*} # 1.28
key_url=https://pkgs.k8s.io/core:/stable:/$ver/deb
key_file=/etc/apt/keyrings/kubernetes.$ver.gpg

if [ ! -f $key_file ]; then
    curl -fsSL $key_url/Release.key | sudo gpg --dearmor -o $key_file
fi

echo "deb [signed-by=$key_file] $key_url /" | sudo tee /etc/apt/sources.list.d/kubernetes.list

apt-get update
# apt-cache madison kubeadm | head || true
apt-mark unhold kubeadm
apt-get -y upgrade kubeadm
apt-mark hold kubeadm

kubeadm upgrade plan
kubeadm upgrade diff $version
kubeadm upgrade node
# kubectl -n kube-system get cm kubeadm-config -o yaml

####
apt-mark unhold kubelet kubectl
apt-get upgrade -y kubelet kubectl
apt-mark hold kubelet kubectl

systemctl daemon-reload
systemctl restart kubelet
