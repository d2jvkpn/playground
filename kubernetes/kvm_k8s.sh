#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

KVM_Network=${KVM_Network:-default}

# bash ../kvm/src/virsh_clone.sh ubuntu k8s-cp{01..03} k8s-node{01..04}
[ $# -eq 0 ] && { >&2 echo "vm name(s) not provided"; exit 1;  }

for vm in $*; do
    [ ! -z $(virsh list --all | awk -v vm=$vm '$2==vm{print 1}') ] && continue
    bash ../kvm/src/virsh_clone.sh ubuntu $vm
done

mkdir -p logs configs

[ ! -f ansible.cfg ] && \
cat > ansible.cfg <<EOF
[defaults]
inventory = ./configs/kvm_k8s.ini
private_key_file = ~/.ssh/kvm_k8s.pem
log_path = ./logs/ansible.log
# roles_path = /path/to/roles
EOF

virsh net-dumpxml $KVM_Network |
  awk "/<host.*name='k8s-/{print}" |
  sed "s#^.*name='##; s#ip='##; s#/>##; s#'##g" |
  awk '{print $2, $1}' > configs/kvm_k8s.txt

[ -s configs/kvm_k8s.txt ] || { >&2 echo "k8s-xx not found!"; exit 1; }

text=$(awk '{print $2, "ansible_host="$1, "ansible_port=22 ansible_user=ubuntu"}' configs/kvm_k8s.txt)

cat > configs/kvm_k8s.ini <<EOF
$text

[k8s_all]
$(echo "$text" | awk '$1!=""{print $1}')

[k8s_cps]
$(echo "$text" | awk '/^k8s-cp/{print $1}')

[k8s_workers]
$(echo "$text" | awk '/^k8s-node/{print $1}')
EOF

rm configs/kvm_k8s.txt
