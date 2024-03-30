#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

export DEBIAN_FRONTEND=nointeractive

#### control-plane
# version=1.28.3
# version=$(yq .k8s.version k8s_apps/k8s_apps_download.yaml)
version=$1

#### 
apt-get update

# apt-cache madison kubeadm | head || true
apt-mark unhold kubeadm
# apt policy kubeadm | head
# apt-get install -y kubeadm=${version}-00
# apt-get install -y kubeadm=${version}-1.1

apt-get upgrade -y kubeadm
apt-mark hold kubeadm
# $(kubectl version -o json | jq -r .clientVersion.gitVersion) == v$version

kubeadm upgrade plan
kubeadm upgrade diff $version

# kubectl -n kube-system get cm kubeadm-config -o yaml
# kubeadm upgrade apply v$version
kubeadm upgrade node
# ....
# kubectl get pod -o wide | grep $node
# kubectl -n kube-system get cm kubeadm-config -o yaml
# kubectl get node/$node -o wide

####
apt-mark unhold kubelet kubectl
# apt-get install -y kubelet=${version}-1.1 kubectl=${version}-1.1
apt-get upgrade -y kubelet kubectl
apt-mark hold kubelet kubectl

systemctl daemon-reload
systemctl restart kubelet
