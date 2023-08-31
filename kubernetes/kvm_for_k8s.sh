#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

KVM_Network=${KVM_Network:-default}

# bash ../kvm/src/virsh_clone.sh ubuntu k8s-cp{01..03} k8s-node{01..03} k8s-ingress01

for vm in ubuntu k8s-cp{01..03} k8s-node{01..03} k8s-ingress01; do
    [ -z $(virsh list --all | awk -v vm=$vm '$2==vm{print 1}') ] || continue
    bash ../kvm/src/virsh_clone.sh $vm
done

mkdir -p logs configs

[ ! -f ansible.cfg ] && \
cat > ansible.cfg <<EOF
[defaults]
inventory = ./configs/hosts.ini
private_key_file = ~/.ssh/kvm.pem
log_path = ./logs/ansible.log
# roles_path = /path/to/roles
EOF

# virsh net-dumpxml $KVM_Network |
#   awk 'BEFIN{print "# k8s nodes"} /host/{print $4, $3}' |
#   sed 's#\x27##g; s#/>##; s#name=##; s#ip=##' > configs/etc_hosts

virsh net-dumpxml $KVM_Network |
  awk "/<host.*name='k8s-/{print}" |
  sed "s#^.*name='##; s#ip='##; s#/>##; s#'##g" |
  awk '{print $2, $1}' > configs/hosts.txt

[ -s configs/hosts.txt ] || { >&2 echo "vm k8s-xx not found!"; exit 1; }

text=$(awk '{print $2, "ansible_host="$1, "ansible_port=22 ansible_user=ubuntu"}' configs/hosts.txt)

{
    echo "$text"
    echo ""

    echo "[k8s_all]"
    echo "$text" | awk '$1!=""{print $1}'
    echo ""

    echo "[k8s_cps]"
    echo "$text" | awk '/^k8s-cp/{print $1}'
    echo ""

    echo "[k8s_workers]"
    echo "$text" | awk '/^k8s-node/{print $1}'
    echo "$text" | awk '/^k8s-ingress/{print $1}'
} > configs/hosts.ini
