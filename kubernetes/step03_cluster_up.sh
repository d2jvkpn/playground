#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

# cp_node=k8s-cp01
cp_node=$1

# cp_node=$(ansible k8s_cps[0] --list-hosts | awk 'NR==2{print $1; exit}')
# cp_node=$(ansible-inventory --list --yaml | yq '.all.children.k8s_cps.hosts | keys | .[0]')

#### 1. set hosts
hosts_yaml=$(ansible-inventory --list --yaml | yq .all.children.k8s_all.hosts)

cp_ip=$(echo "$hosts_yaml" | yq ".$cp_node.ansible_host")

mkdir -p k8s.local/data

cat > ./k8s.local/data/hosts.txt << EOF

#### kubernetes
$cp_ip k8s-control-plane

$(cat configs/k8s_hosts.txt)
EOF

ansible k8s_all -m file -a "path=./k8s.local/data state=directory"
# ansible k8s_all -m copy -a "src=k8s.local/data/hosts.txt dest=./k8s.local/data/"

ansible k8s_all -m synchronize -a "mode=push src=k8s.local/data/ dest=./k8s.local/data/"

ansible k8s_all -m shell --become -a 'cat k8s.local/data/hosts.txt >> /etc/hosts'

#### 2. k8s init and join the cluster
ansible $cp_node -m shell --become -a \
  "bash k8s_scripts/k8s_node_cp.sh k8s-control-plane:6443"
# ansible $cp_node -m shell -a "sudo kubeadm reset -f"

ansible $cp_node --one-line -m fetch \
  -a "flat=true src=k8s.local/data/kubeadm-init.yaml dest=k8s.local/data/"

# kubectl join, don't use --become instead sudo
ansible k8s_workers -m shell -a "sudo $(bash k8s_scripts/k8s_command_join.sh worker)"

ansible k8s_cps[1:] -m shell -a "sudo $(bash k8s_scripts/k8s_command_join.sh control-plane)"

#### 3. post
ansible k8s_cps -a 'sudo bash k8s_scripts/kube_copy_config.sh root $USER'

# echo "$hosts_yaml" | yq 'keys() | join(" ")'
for node in $(ansible k8s_workers --list-hosts | sed '1d'); do
    ansible $cp_node --one-line \
      -a "kubectl label node/$node --overwrite node-role.kubernetes.io/worker="
done

#### 4. sync data and kube
# rsync -arPv $cp_node:k8s.local/data/ k8s.local/data/
ansible $cp_node -m synchronize -a "mode=pull src=k8s.local/data/ dest=./k8s.local/data"

ansible $cp_node -m synchronize -a "mode=pull src=.kube dest=~/"

# cp_ip=$(awk -v name=$cp_node '$2==name{print $1}' configs/k8s_hosts.txt)
sed -i "s#//k8s-control-plane:#//$cp_ip:#" ~/.kube/config

kubectl get ns

kubectl create ns dev
kubectl config set-context --current --namespace=dev

# kubectl config view --minify -o jsonpath='{..namespace}'
# kubectl config view | grep namespace
