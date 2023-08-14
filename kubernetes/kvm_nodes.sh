#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

KVM_Network=${KVM_Network:-default}

[ ! -f ansible.cfg ] && \
cat > ansible.cfg <<EOF
[defaults]
inventory = ./configs/hosts.ini
private_key_file = ~/.ssh/kvm.pem
# roles_path = /path/to/roles
EOF

mkdir -p configs

# virsh net-dumpxml $KVM_Network |
#   awk 'BEFIN{print "# k8s nodes"} /host/{print $4, $3}' |
#   sed 's#\x27##g; s#/>##; s#name=##; s#ip=##' > configs/etc_hosts

virsh net-dumpxml $KVM_Network |
  grep "<host" |
  sed "s#^.*name='##; s#ip='##; s#/>##; s#'##g" |
  awk '{print $2, "k8s_"$1}' > configs/etc_hosts

awk '{print $2, "ansible_host="$1}' configs/etc_hosts |
  sed 's#$# ansible_port=22 ansible_user=ubuntu ansible_user=ubuntu#' |
  sed '1i[k8s_all]' > configs/hosts.ini
