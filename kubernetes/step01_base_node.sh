#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

network=${network:-default}

# args: ubuntu k8s-cp01
vm_src=$1; target=$2
mkdir -p logs configs

#### 1. create a new node
if [ -z "$(virsh list --all | awk -v vm=$target '$2==vm{print 1}')" ]; then
    shutdown_vm=false bash ../kvm/virsh_clone.sh $vm_src $target
fi

virsh net-dumpxml $network |
  awk "/<host.*name='k8s-/{print}" |
  sed "s#^.*name='##; s#ip='##; s#/>##; s#'##g" |
  awk '{print $2, $1}' > configs/k8s_hosts.txt

awk '{print $2, "ansible_host="$1, "ansible_port=22 ansible_user=ubuntu"}' \
  configs/k8s_hosts.txt > configs/k8s_hosts.ini

n=1
# while ! ansible $target --one-line -m ping; do
while ! ssh -o StrictHostKeyChecking=no $target exit; do
    sleep 1
    n=$((n+1))
    [ $n -gt 30 ] && { >&2 echo "can't access node $target"; exit 1; }
done

#### 2. copy assets
# ansible $target --one-line -m copy -a "src=k8s_scripts dest=./"
# ansible $target --one-line -m copy -a "src=k8s_demos dest=./"
# ansible $target --one-line --forks 2 -m copy -a "src=k8s.local dest=./"
# rsync -arPv ./k8s.local $target:./

ansible $target --one-line -m synchronize -a "mode=push src=k8s_scripts dest=./"

ansible $target --one-line -m synchronize -a "mode=push src=k8s_demos dest=./"

ansible $target --one-line -m synchronize -a "mode=push src=k8s.local dest=./"

ansible $target -m shell --become \
  -a "swapoff --all && sed -i '/swap/d' /etc/fstab && rm -f /swap.img"

#### 3. k8s installation
version=$(yq .k8s.version k8s.local/k8s_download.yaml)

ansible $target -m shell \
  -a "sudo bash k8s_scripts/k8s_node_install.ubuntu.sh $version"

ansible $target --forks 4 -m shell \
  -a "sudo import_image=true bash k8s_scripts/k8s_apps_install.sh"

ansible $target -m file -a "path=./k8s.local/images state=absent"

#### 4. shutdown
virsh shutdown $target

bash ../kvm/virsh_wait_until.sh $target "shut off" 180
