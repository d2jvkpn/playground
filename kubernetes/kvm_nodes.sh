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

virsh net-dumpxml $KVM_Network |
  awk '/host/{print $3, $4}' |
  sed 's#\x27##g; s#/>##; s#name=##; s#ip=##' |
  sed 's#$# ansible_port=22 ansible_user=ubuntu ansible_user=ubuntu#' |
  awk 'BEGIN{print "[k8s_all]"}
  /node/{$2="ansible_host="$2; print} END{print; print "[k8s_workers]"}' > configs/hosts.ini
