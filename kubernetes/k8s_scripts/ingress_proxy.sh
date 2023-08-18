#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

# @reboot bash ~/Apps/cron/ingress_proxy.sh node01

ingress_node=$1
local_port=${2:-8080}

ingress_ip=$(ssh -G $ingress_node | awk '$1=="hostname"{print $2}')

ssh -f -gN -L $local_port:$ingress_ip:80 $ingress_node
