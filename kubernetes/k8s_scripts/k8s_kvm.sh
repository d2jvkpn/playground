#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

KVM_Network=${KVM_Network:-default}
vm_src=${vm_src:-ubuntu}

# args: k8s-cp{01..03} k8s-node{01..04}
[ $# -eq 0 ] && { >&2 echo "vm name(s) not provided"; exit 1;  }

target=$1
shift
vms="$*"

mkdir -p logs configs

#### 1. create the first node
if [ -z $(virsh list --all | awk -v vm=$target '$2==vm{print 1}') ]; then
    bash ../kvm/src/virsh_clone.sh $vm_src $target
fi

while ! ansible $target --one-line -m ping; do
    sleep 1
done
echo ""

virsh net-dumpxml $KVM_Network |
  awk "/<host.*name='k8s-/{print}" |
  sed "s#^.*name='##; s#ip='##; s#/>##; s#'##g" |
  awk '{print $1, "ansible_host="$2, "ansible_port=22 ansible_user=ubuntu"}' > configs/kvm_k8s.ini

####
set -x

ansible $target --one-line -m copy -a "src=k8s_scripts dest=./"
ansible $target --one-line -m copy -a "src=k8s_demos dest=./"
ansible $target --forks 2 -m copy -a "src=./k8s_apps dest=./"

ansible $target -m shell --become \
  -a "swapoff --all && sed -i '/swap/d' /etc/fstab && rm -f /swap.img"

ansible $target -m file -a "path=./k8s_apps/images state=absent"

#### 2. k8s installation
version=$(yq .version k8s_apps/k8s.yaml)

ansible $target -m shell -a "sudo bash k8s_scripts/k8s_node_install.sh $version"
# ?? sysctl: setting key "net.ipv4.conf.all.accept_source_route": Invalid argument
# ?? sysctl: setting key "net.ipv4.conf.all.promote_secondaries": Invalid argument

ansible $target -m shell -a "sudo bash k8s_scripts/k8s_apps_containerd.sh"

ansible $target --forks 4 -m shell \
  -a "sudo import_local_image=true bash k8s_scripts/k8s_apps_install.sh"

set +x

#### 3. clone nodes
for vm in $vms; do
    [ ! -z $(virsh list --all | awk -v vm=$vm '$2==vm{print 1}') ] && continue
    bash ../kvm/src/virsh_clone.sh $target $vm
done

#### 4. generate configs/kvm_k8s.ini
[ ! -s ansible.cfg ] && \
cat > ansible.cfg <<EOF
[defaults]
inventory = ./configs/kvm_k8s.ini
private_key_file = ~/.ssh/kvm/kvm.pem
log_path = ./logs/ansible.log
# roles_path = /path/to/roles
EOF

virsh net-dumpxml $KVM_Network |
  awk "/<host.*name='k8s-/{print}" |
  sed "s#^.*name='##; s#ip='##; s#/>##; s#'##g" |
  awk '{print $2, $1}' > configs/kvm_k8s.txt

[ -s configs/kvm_k8s.txt ] || { >&2 echo "k8s-xx not found!"; exit 1; }

text=$(awk '{print $2, "ansible_host="$1, "ansible_port=22 ansible_user=ubuntu"}' configs/kvm_k8s.txt)

cat > configs/kvm_k8s.ini <<EOF
$text

[k8s_all]
$(echo "$text" | awk '$1!=""{print $1}')

[k8s_cps]
$(echo "$text" | awk '/^k8s-cp/{print $1}')

[k8s_workers]
$(echo "$text" | awk '/^k8s-node/{print $1}')
EOF
