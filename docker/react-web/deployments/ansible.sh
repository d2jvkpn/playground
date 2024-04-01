#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

app_env=$1

time ansible-playbook "${_path}/ansible.playbook.yaml" -vv --inventory=hosts.ini \
  --extra-vars="app_env=$app_env"
