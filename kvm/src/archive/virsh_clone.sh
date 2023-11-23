#! /usr/bin/env bash
set -eu -o pipefail

_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})
# set -x

vm_source=$1

if [ $# -gt 2 ]; then
    # recursion
    shift
    for target in $*; do
        bash $0 $vm_source $target
    done
    exit 0
else
    target=$2
fi

####
KVM_User="${KVM_User:-ubuntu}"
KVM_SSH_Key="${KVM_SSH_Key:-$HOME/.ssh/kvm.pem}"
KVM_SSH_Config=${KVM_SSH_Config:-$HOME/.ssh/kvm.conf}

echo "==> Cloning $vm_source into $target, KVM_User: $KVM_User, KVM_SSH_Key: $KVM_SSH_Key"

####
echo "==> Shutting down $vm_source"
virsh shutdown $vm_source 2>/dev/null || true

while [[ "$(virsh domstate --domain $vm_source | awk 'NR==1{print $0; exit}')" != "shut off" ]]; do
    echo -n "."; sleep 1
done
echo ""
echo "==> VM $vm_source is shut off"

virt-clone --original $vm_source --name $target --file /var/lib/libvirt/images/$target.qcow2
# virt-clone --original $vm_source --vm_source $target --auto-clone

####
bash ${_path}/virsh_fix_ip.sh $target

addr=$(
  virsh domifaddr $target |
  awk 'NR>2 && $1!=""{split($NF, a, "/"); addr=a[1]} END{print addr}'
)

echo "==> Got vm addrss: $addr"

cat >> $KVM_SSH_Config << EOF
Host $target
    HostName      $addr
    User          $KVM_User
    Port          22
    LogLevel      INFO
    Compression   yes
    IdentityFile  $KVM_SSH_Key
EOF

bash ${_path}/wait_for_tcp_port.sh $addr 22

# addr=$(ssh -G $target | awk '/^hostname/{print $2}')
ssh-keygen -f ~/.ssh/known_hosts -R $addr
ssh-keyscan -H $addr >> ~/.ssh/known_hosts
# ssh-keygen -F $addr || ssh-keyscan -H $addr >> ~/.ssh/known_hosts
ssh-copy-id -i $KVM_SSH_Key $target

ssh $target sudo hostnamectl set-hostname $target

ssh $target sudo sed -i \'"2s/^127.0.1.1 .*$/127.0.1.1 $target/"\' /etc/hosts
# virsh shutdown $target
