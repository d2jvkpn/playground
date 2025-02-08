#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

if [ $# -gt 1 ]; then
    for arg in $*; do bash $0 $arg; done
    exit 0
else
    username=$1
fi

if [ "$username" == "root" ]; then
    kube_dir=/root/.kube
else
    kube_dir=/home/$username/.kube
fi

mkdir -p $kube_dir

cp -f /etc/kubernetes/admin.conf $kube_dir/config
chown -R $username:$username $kube_dir

# export KUBECONFIG=/etc/kubernetes/admin.conf
# echo -e '\n\nexport KUBECONFIG=/etc/kubernetes/admin.conf' > ~/.bashrc
