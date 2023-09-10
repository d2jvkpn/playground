#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

key_file=/etc/apt/keyrings/kubernetes.gpg
[ -f key_file ] && rm -f key_file

#### aliyun repository
curl -fsSL https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg |
  sudo gpg --dearmor -o $key_file

echo "deb [signed-by=$key_file] https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main" |
  sudo tee /etc/apt/sources.list.d/kubernetes.list

#### google repository
curl -fsSL https://dl.k8s.io/apt/doc/apt-key.gpg | sudo gpg --dearmor -o $key_file

echo "deb [signed-by=$key_file] https://apt.kubernetes.io/ kubernetes-xenial main" |
  sudo tee /etc/apt/sources.list.d/kubernetes.list

#### apt install
apt-get update
# sudo apt-get install -y kubectl kubelet kubeadm
apt install -y kubelet=${version}-00 kubeadm=${version}-00 kubectl=${version}-00

apt-mark hold kubelet kubeadm kubectl
# apt-mark unhold kubelet kubeadm kubectl
# systemctl disable kubelet
