#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

k8s_rep=$1

key_file=/etc/apt/keyrings/kubernetes.gpg
[ -f key_file ] && sudo rm -f $key_file

case "$k8s_rep" in
"aliyun")
    curl -fsSL https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg |
      sudo gpg --dearmor -o $key_file

    echo "deb [signed-by=$key_file] https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main" |
      sudo tee /etc/apt/sources.list.d/kubernetes.list
    ;;
"google")
    curl -fsSL https://dl.k8s.io/apt/doc/apt-key.gpg | sudo gpg --dearmor -o $key_file

    echo "deb [signed-by=$key_file] https://apt.kubernetes.io/ kubernetes-xenial main" |
      sudo tee /etc/apt/sources.list.d/kubernetes.list
    ;;
*)
    >&2 echo "unknown k8s repository"
    exit 1
    ;;
esac

sudo apt-get update
sudo apt install -y kubelet=${version}-00 kubeadm=${version}-00 kubectl=${version}-00
apt-mark hold kubelet kubeadm kubectl

exit
apt-mark unhold kubelet kubeadm kubectl
