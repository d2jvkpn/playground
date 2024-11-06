#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

# cp_node=k8s-cp01
cp_node=$(awk '$1!=""{print $1; exit}' configs/k8s_hosts.ini)
cp_ip=$(awk '$1!=""{sub(/.*=/, "", $2); print $2; exit}' configs/k8s_hosts.ini)

# cp_node=$(ansible k8s_cps[0] --list-hosts | awk 'NR==2{print $1; exit}')

# cp_node=$(
#   ansible-inventory --list --yaml |
#   yq '.all.children.k8s_cps.hosts | keys | .[0]'
# )

mkdir -p k8s.local/data

#### 1. set hosts
ansible k8s_all -m file -a "path=./k8s.local/data state=directory"

#### 2. k8s init and join the cluster
ansible $cp_node -m shell --become -a "bash k8s_scripts/k8s_node_cp.sh $cp_ip:6443"
# ansible $cp_node -m shell -a "sudo kubeadm reset -f"

ansible $cp_node --one-line -m fetch \
  -a "flat=true src=k8s.local/data/kubeadm-init.yaml dest=k8s.local/data/"

# kubectl join, don't use --become instead sudo
ansible k8s_workers -m shell \
  -a "sudo $(bash k8s_scripts/k8s_command_join.sh worker)"

ansible k8s_cps[1:] -m shell \
  -a "sudo $(bash k8s_scripts/k8s_command_join.sh control-plane)"

#### 3. post
ansible k8s_cps -a 'sudo bash k8s_scripts/kube_copy_config.sh root $USER'

# echo "$hosts_yaml" | yq 'keys() | join(" ")'
for node in $(ansible k8s_workers --list-hosts | sed '1d'); do
    ansible $cp_node --one-line \
      -a "kubectl label node/$node --overwrite node-role.kubernetes.io/worker="
done

#### 4. sync data and kube
# rsync -arPv $cp_node:k8s.local/data/ k8s.local/data/
ansible $cp_node -m synchronize \
  -a "mode=pull src=k8s.local/data/ dest=./k8s.local/data"

ansible $cp_node -m synchronize -a "mode=pull src=.kube dest=~/"

kubectl get ns

kubectl create ns dev
kubectl config set-context --current --namespace=dev

# kubectl config view --minify -o jsonpath='{..namespace}'
# kubectl config view | grep namespace
