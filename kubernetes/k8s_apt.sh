#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})


# ansible k8s_all -m shell --become -a 'apt update'
# ansible k8s_all -m shell --become -a 'DEBIAN_FRONTEND=nointeractive apt -y upgrade'

# https://docs.ansible.com/ansible/latest/collections/ansible/builtin/apt_module.html

ansible k8s_all -m apt --become -a 'update_cache=yes'
ansible k8s_all -m apt --become -a 'upgrade=yes'

ansible k8s_all -m apt --become -a 'clean=yes autoclean=yes autoremove=yes'

####
ansible k8s_all -a 'uptime'

ansible k8s_cps[0] -m shell -a "kubectl get pods -A -o wide | sort -k 8"

# --inventory=configs/k8s_hosts.ini
ansible-playbook reboot-required.ansible.yaml -v --extra-vars="host=k8s_all"
