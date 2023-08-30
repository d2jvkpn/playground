#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

KVM_Network=${KVM_Network:-default}

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
  sed "s#^.*name='##; s#ip='##; s#/>##; s#'##g" > configs/hosts.tmp

[ -s configs/hosts.tmp ] || { >&2 echo "vm k8s-xx not found!"; exit 1; }

sed 's/ / ansible_host=/; s/$/ ansible_port=22 ansible_user=ubuntu/' configs/hosts.tmp |
  sed '1i [k8s_all]' > configs/hosts.ini

{
    echo -e "\n[k8s_cps]"
    grep "^k8s-cp" configs/hosts.ini

    echo -e "\n[k8s_workers]"
    grep "^k8s-node" configs/hosts.ini
    grep "^k8s-ingress" configs/hosts.ini
} > configs/hosts.tmp

cat configs/hosts.tmp >> configs/hosts.ini
rm configs/hosts.tmp
