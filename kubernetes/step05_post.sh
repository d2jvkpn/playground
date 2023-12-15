#! /usr/bin/env bash
set -eu -o pipefail

_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})
# set -x

cp_node=$1

#### 1. storage
ansible $cp_node -m shell -a "sudo bash k8s_scripts/kube_storage_nfs.sh $cp_node 10Gi"
# node=k8s-cp02
# ansible $node -m shell --become -a "namespace=prod bash k8s_scripts/kube_storage_nfs.sh $node 10Gi"

#### 2. create and set default namespace dev
ansible k8s_cps -m shell -a 'sudo bash k8s_scripts/kube_copy_config.sh root $USER'

ansible $cp_node -m shell --become -a 'kubectl create ns dev'
ansible k8s_cps -m shell -a 'kubectl config set-context --current --namespace=dev'

# kubectl config view --minify -o jsonpath='{..namespace}'
# kubectl config view | grep namespace

#### 3. expose k8s cluster port 5432
ansible $cp_node -m shell -a "sudo bash k8s_scripts/kube_tcp-services.sh postgres 5432"

#### 3. sync data
# rsync -arPv $cp_node:k8s_apps/data/ k8s_apps/data/
ansible $cp_node -m synchronize -a "mode=pull src=k8s_apps/data/ dest=./k8s_apps/data"

exit
# ansible k8s_all -m shell --become -a 'apt update'
# ansible k8s_all -m shell --become -a 'DEBIAN_FRONTEND=nointeractive apt -y upgrade'

# https://docs.ansible.com/ansible/latest/collections/ansible/builtin/apt_module.html

ansible k8s_all -m apt --become -a 'update_cache=yes'
ansible k8s_all -m apt --become -a 'upgrade=yes'

ansible k8s_all -m apt --become -a 'clean=yes autoclean=yes autoremove=yes'

# --inventory=configs/k8s_hosts.ini
ansible-playbook reboot-required.yaml -v --extra-vars="host=k8s_all"

ansible k8s_all -a 'uptime'
