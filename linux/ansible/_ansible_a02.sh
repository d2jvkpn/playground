#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

####
ansible k8s_all --one-line -m shell -a 'echo "Hello, world!"'
ansible k8s_all[0] --one-line -m ping
ansible k8s_all[1:] --one-line -m ping
ansible k8s_all --one-line -m debug
ansible k8s_all[0] --list-hosts
