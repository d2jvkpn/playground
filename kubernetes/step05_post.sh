#! /usr/bin/env bash
set -eu -o pipefail

_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})
# set -x

cp_node=$1

# rsync -arPv $cp_node:k8s_apps/data/ k8s_apps/data/
ansible $cp_node -m synchronize -a "mode=pull src=k8s_apps/data/ dest=./k8s_apps/data"

exit
# ansible k8s_all -m shell --become -a 'apt update'
# ansible k8s_all -m shell --become -a 'DEBIAN_FRONTEND=nointeractive apt -y upgrade'

# https://docs.ansible.com/ansible/latest/collections/ansible/builtin/apt_module.html

ansible k8s_all -m apt --become -a 'update_cache=yes'
ansible k8s_all -m apt --become -a 'upgrade=yes'

ansible k8s_all -m apt --become -a 'clean=yes autoclean=yes autoremove=yes'

# --inventory=configs/k8s_hosts.ini
ansible-playbook -v reboot-required.yaml --extra-vars="host=k8s_all"

ansible k8s_all -a 'uptime'
