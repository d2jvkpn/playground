#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})


virsh start $name
addr=""
echo "==> allocating ip for $name"
while true; do
    addr=$(virsh domifaddr $name | awk 'NR>2 && $1!=""{split($NF, a, "/"); addr=a[1]} END{print addr}')
    [[ -z $"$addr" ]] || break
    echo -n "."
    sleep 1
done
echo


state=$(virsh domstate --domain $name | awk 'NR==1{print $0; exit}')
echo "==> shutting down $name"

if [[ "$state" == "running" ]]; then
    virsh shutdown $vm
else
    while true; do
        state=$(virsh domstate --domain $name | awk 'NR==1{print $0; exit}')
        echo -n "."
        [[ "$state" == "shut off" ]] && break
        sleep 1
    done
    echo ""
fi
