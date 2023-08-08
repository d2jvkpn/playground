#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

username=$1

kube_dir=/home/$username/.kube
mkdir -p $kube_dir

cp -f /etc/kubernetes/admin.conf $kube_dir/config

chown $username:$username $kube_dir/config

# export KUBECONFIG=/etc/kubernetes/admin.conf
# echo -e '\n\nexport KUBECONFIG=/etc/kubernetes/admin.conf' > ~/.bashrc
