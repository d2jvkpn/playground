#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


# ansible k8s_all -m shell --become -a 'apt update'
# ansible k8s_all -m shell --become -a 'DEBIAN_FRONTEND=nointeractive apt -y upgrade'

# https://docs.ansible.com/ansible/latest/collections/ansible/builtin/apt_module.html

ansible k8s_all -m apt --become -a 'update_cache=yes'
ansible k8s_all -m apt --become -a 'upgrade=yes'

ansible k8s_all -m apt --become -a 'clean=yes autoclean=yes autoremove=yes'

####
ansible k8s_all -a 'uptime'

ansible k8s_cps[0] -m shell -a "kubectl get pods -A -o wide | sort -k 8"
