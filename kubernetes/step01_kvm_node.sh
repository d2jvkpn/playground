#! /usr/bin/env bash
set -eu -o pipefail

_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})
# set -x

KVM_Network=${KVM_Network:-default}

# args: ubuntu k8s-cp01
[ $# -eq 0 ] && { >&2 echo "vm name(s) not provided"; exit 1;  }

vm_src=$1; target=$2

mkdir -p logs configs

#### 1. create the first node
if [ -z "$(virsh list --all | awk -v vm=$target '$2==vm{print 1}')" ]; then
    bash ../kvm/src/virsh_clone.sh $vm_src $target
fi

virsh net-dumpxml $KVM_Network |
  awk "/<host.*name='k8s-/{print}" |
  sed "s#^.*name='##; s#ip='##; s#/>##; s#'##g" |
  awk '{print $1, "ansible_host="$2, "ansible_port=22 ansible_user=ubuntu"}' > configs/kvm_k8s.ini

virsh start $target || true

while ! ansible $target --one-line -m ping; do
    sleep 1
done

####
set -x

ansible $target --one-line -m copy -a "src=k8s_scripts dest=./"
ansible $target --one-line -m copy -a "src=k8s_demos dest=./"
ansible $target --one-line -m copy -a "src=k8s_apps dest=./"
# ansible $target --forks 2 -m copy -a "src=k8s_apps dest=./"

ansible $target -m shell --become \
  -a "swapoff --all && sed -i '/swap/d' /etc/fstab && rm -f /swap.img"

#### 2. k8s installation
version=$(yq .version k8s_apps/k8s.yaml)

ansible $target -m shell -a "sudo bash k8s_scripts/k8s_node_install.sh $version"
# ?? sysctl: setting key "net.ipv4.conf.all.accept_source_route": Invalid argument
# ?? sysctl: setting key "net.ipv4.conf.all.promote_secondaries": Invalid argument

ansible $target -m shell -a "sudo bash k8s_scripts/k8s_apps_containerd.sh"

ansible $target --forks 4 -m shell \
  -a "sudo import_local_image=true bash k8s_scripts/k8s_apps_install.sh"

ansible $target -m file -a "path=./k8s_apps/images state=absent"
