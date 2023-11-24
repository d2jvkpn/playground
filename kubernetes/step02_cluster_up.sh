#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

set -x

mkdir -p k8s_apps/data

# cp_node=$(ansible k8s_cps[0] --list-hosts | awk 'NR==2{print $1; exit}')
# cp_node=$(ansible-inventory --list --yaml | yq '.all.children.k8s_cps.hosts | keys | .[0]')

cp_node=${cp_node:-k8s-cp01}
ingress_node=${ingress_node:-k8s-node01}

#### 1.
cp_ip=$(ansible-inventory --list --yaml | yq ".all.children.k8s_all.hosts.$cp_node.ansible_host")

ingress_ip=$(
  ansible-inventory --list --yaml |
  yq ".all.children.k8s_all.hosts.$ingress_node.ansible_host"
)

cat > ./k8s_apps/data/hosts.txt << EOF

$cp_ip k8s-control-plane
$ingress_ip k8s.local

$(cat configs/kvm_k8s.txt)
EOF

ansible k8s_all -m file -a "path=./k8s_apps/data state=directory"
ansible k8s_all -m copy --become -a "src=./k8s_apps/data/hosts.txt dest=./k8s_apps/data/"
ansible k8s_all -m shell --become -a "cat ./k8s_apps/data/hosts.txt >> /etc/hosts"

#### 2.
ansible $cp_node -m shell --become -a "bash k8s_scripts/k8s_node_cp.sh k8s-control-plane:6443"
# ansible $cp_node -m shell -a "sudo kubeadm reset -f"

ansible $cp_node --one-line -m fetch -a \
  "flat=true src=k8s_apps/data/kubeadm-init.yaml dest=k8s_apps/data/"

# kubectl join
ansible k8s_workers -m shell -a "sudo $(bash k8s_scripts/k8s_command_join.sh worker)"
ansible k8s_cps[1:] -m shell -a "sudo $(bash k8s_scripts/k8s_command_join.sh control-plane)"

ansible k8s_cps -m shell -a 'sudo bash k8s_scripts/kube_copy_config.sh root $USER'
ansible k8s_cps -m shell -a 'kubectl config set-context --current --namespace=dev'

# kubectl label node/$ingress_node --overwrite node-role.kubernetes.io/ingress=
# kubectl label node/$ingress_node --overwrite node-role.kubernetes.io/ingress-

# kubectl label
for node in $(ansible k8s_workers --list-hosts | awk 'BEGIN{ORS=" "} /k8s-node/{print $1}'); do
    if [ "$node" == "$ingress_node" ]; then continue; fi
    ansible $cp_node --one-line -a "kubectl label node/$node --overwrite node-role.kubernetes.io/worker="
done

#### 3.
ansible $cp_node -m shell -a "sudo bash k8s_scripts/kube_apply_flannel.sh"

ansible $cp_node -m shell -a "sudo bash k8s_scripts/kube_apply_ingress.sh $ingress_node"
ansible $cp_node -m shell -a "sudo bash k8s_scripts/kube_tcp-services.sh postgres 5432"

ansible $cp_node -m shell -a "sudo bash k8s_scripts/kube_apply_metrics-server.sh"
