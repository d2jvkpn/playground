#! /usr/bin/env bash
set -eu -o pipefail

_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})
# set -x

vm_src=$1
shutdown_vm=${shutdown_vm:-"true"}

if [ $# -gt 2 ]; then
    # recursion
    shift
    for target in $*; do
        bash $0 $vm_src $target
    done
    exit 0
else
    target=$2
fi

####
KVM_User="${KVM_User:-ubuntu}"
KVM_SSH_Dir=${KVM_SSH_Dir:-$HOME/.ssh/kvm}
base=$(basename $KVM_SSH_Dir)
ssh_key="$KVM_SSH_Dir/$base.pem"

echo "==> Cloning $vm_src into $target, KVM_User: $KVM_User, ssh_key: $ssh_key"

####
echo "==> Shutting down $vm_src"
virsh shutdown $vm_src 2>/dev/null || true
bash ${_path}/virsh_wait_until.sh $vm_src "shut off" 180

virt-clone --original $vm_src --name $target --file /var/lib/libvirt/images/$target.qcow2
# virt-clone --original $vm_src --vm_src $target --auto-clone

####
bash ${_path}/virsh_fix_ip.sh $target

addr=$(
  virsh domifaddr $target |
  awk 'NR>2 && $1!=""{split($NF, a, "/"); addr=a[1]} END{print addr}'
)

echo "==> Got vm addrss: $addr"

mkdir -p $KVM_SSH_Dir

cat > $KVM_SSH_Dir/$target.conf << EOF
Host $target
    HostName      $addr
    User          $KVM_User
    Port          22
    LogLevel      INFO
    Compression   yes
    IdentityFile  $ssh_key
EOF

# wait_for_tcp_port.sh $addr 22

# ERROR: "System is booting up. Unprivileged users are not permitted to log in yet. Please come back later. For technical details, see pam_nologin(8)."
n=1
while ! ssh -o StrictHostKeyChecking=no $target exit; do
    sleep 1
    n=$((n+1))
    [ $n -gt 30 ] && { >&2 echo "can't access node $target"; exit 1; }
done

# addr=$(ssh -G $target | awk '/^hostname/{print $2}')
ssh-keygen -f ~/.ssh/known_hosts -R $addr
ssh-keyscan -H $addr >> ~/.ssh/known_hosts
# ssh-keygen -F $addr || ssh-keyscan -H $addr >> ~/.ssh/known_hosts
ssh-copy-id -i $ssh_key $target

ssh -t $target "sudo hostnamectl set-hostname $target"
ssh -t $target 'sudo sed -i "2s/^127.0.1.1 .*$/127.0.1.1 '$target'/" /etc/hosts'

####
if [[ "$shutdown_vm" != "false" ]]; then
    virsh shutdown $target
    vm_state_until $target "shut off"
fi
