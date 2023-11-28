#! /usr/bin/env bash
set -eu -o pipefail

_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})
# set -x

KVM_Network=${KVM_Network:-default}
vm_src=${vm_src:-ubuntu}

# args: k8s-cp01 k8s-cp{02,03} k8s-node{01..04}
[ $# -eq 0 ] && { >&2 echo "vm name(s) not provided"; exit 1; }

array=($*)
target=${array[@]:0:1}; nodes=${array[@]:1}

mkdir -p logs configs

#### 1. clone nodes
for node in $nodes; do
    [ ! -z $(virsh list --all | awk -v node=$node '$2==node{print 1}') ] && continue
    echo "==> cloning $target into node"
    shutdown_vm=false bash ../kvm/virsh_clone.sh $target $node
done

echo "==> start $target"
virsh start $target || true
sleep 5

for node in $nodes $target; do
    n=1
    while ! ssh -o StrictHostKeyChecking=no $node exit; do
        sleep 1
        n=$((n+1))
        [ $n -gt 30 ] && { >&2 echo "can't access node $node"; exit 1; }
    done
done

#### 2. generate configs/k8s_hosts.ini
[ ! -s ansible.cfg ] && \
cat > ansible.cfg <<EOF
[defaults]
inventory = ./configs/k8s_hosts.ini
private_key_file = ~/.ssh/kvm/kvm.pem
log_path = ./logs/ansible.log
# roles_path = /path/to/roles
EOF

virsh net-dumpxml $KVM_Network |
  awk "/<host.*name='k8s-/{print}" |
  sed "s#^.*name='##; s#ip='##; s#/>##; s#'##g" |
  awk '{print $2, $1}' > configs/k8s_hosts.txt

[ -s configs/k8s_hosts.txt ] || { >&2 echo "k8s-xx not found!"; exit 1; }

text=$(
  awk '{print $2,"ansible_host="$1,"ansible_port=22 ansible_user=ubuntu"}' configs/k8s_hosts.txt
)


cat > configs/k8s_hosts.ini <<EOF
$text

[k8s_all]
$(echo "$text" | awk '$1!=""{print $1}')

[k8s_cps]
$(echo "$text" | awk '/^k8s-cp/{print $1}')

[k8s_workers]
$(echo "$text" | awk '/^k8s-node/{print $1}')
EOF

cat configs/k8s_hosts.ini

exit

cat < configs/k8s_hosts.ini << EOF
k8s-cp01 ansible_host=192.168.122.11 ansible_port=22 ansible_user=ubuntu
k8s-cp02 ansible_host=192.168.122.12 ansible_port=22 ansible_user=ubuntu
k8s-cp03 ansible_host=192.168.122.13 ansible_port=22 ansible_user=ubuntu
k8s-node01 ansible_host=192.168.122.21 ansible_port=22 ansible_user=ubuntu
k8s-node02 ansible_host=192.168.122.22 ansible_port=22 ansible_user=ubuntu
k8s-node03 ansible_host=192.168.122.23 ansible_port=22 ansible_user=ubuntu
k8s-node04 ansible_host=192.168.122.24 ansible_port=22 ansible_user=ubuntu

[k8s_all]
k8s-cp01
k8s-cp02
k8s-cp03
k8s-node01
k8s-node02
k8s-node03
k8s-node04

[k8s_cps]
k8s-cp01
k8s-cp02
k8s-cp03

[k8s_workers]
k8s-node01
k8s-node02
k8s-node03
k8s-node04
EOF
