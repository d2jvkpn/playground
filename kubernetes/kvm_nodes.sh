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
  awk "/<host.*name='node/{print} /<host.*name='cp/{print} /<host.*name='ingress/{print}" |
  sed "s#^.*name='##; s#ip='##; s#/>##; s#'##g" |
  awk 'BEGIN{OFS="\t"; print "hostname", "ip"} {print $1, $2}' > configs/hosts.tsv

awk 'BEGIN{print "[k8s_all]"} NR>1{
    $2="ansible_host="$2;
    $0=$0"  ansible_port=22 ansible_user=ubuntu";
    print;
  }' configs/hosts.tsv > configs/hosts.ini
