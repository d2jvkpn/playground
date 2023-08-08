#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

host=$1   # host(s) defined in $host_file
script=$2 # yaml file path

host_file=${_path}/configs/hosts.ini

# -vv -vvv
ansible-playbook -v $script \
  --inventory=$host_file \
  --extra-vars="host=$host"
