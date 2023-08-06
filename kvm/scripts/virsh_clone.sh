#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

vm_source=$1; target=$2

####
KVM_User="${KVM_User:-hello}"
KVM_SSH_Key="${KVM_SSH_Key:-~/.ssh/kvm.pem}"

####
echo "==> Shutting down $vm_source"
virsh shutdown $vm_source 2>/dev/null || true

state=""
while [[ "$state" != "shut off" ]]; do
    state=$(virsh domstate --domain $vm_source | awk 'NR==1{print $0; exit}')
    echo -n "."; sleep 1
done
echo

virt-clone --original $vm_source --name $target --file /var/lib/libvirt/images/$target.qcow2
# virt-clone --original $vm_source --vm_source $target --auto-clone

####
bash ${_path}/virsh_fix_ip.sh $target

addr=$(
  virsh domifaddr $target |
  awk 'NR>2 && $1!=""{split($NF, a, "/"); addr=a[1]} END{print addr}'
)

echo "==> Got vm addrss: $addr"

cat >> ~/.ssh/config << EOF
Host $target
    HostName      $addr
    User          $KVM_User
    Port          22
    LogLevel      INFO
    Compression   yes
    IdentityFile  $KVM_SSH_Key
EOF

# addr=$(ssh -G $target | awk '/^hostname/{print $2}')

ssh-keygen -F || ssh-keyscan -H $addr >> ~/.ssh/known_hosts
# remove: ssh-keygen -f ~/.ssh/known_hosts -R $addr

bash ${_path}/wait_for_tcp_port.sh $addr 22

# -f
ssh-copy-id -i $KVM_SSH_Key $target || true

ssh $target sudo hostnamectl set-hostname $target
ssh $target sudo sed -i \'"2s/^127.0.1.1 .*$/127.0.1.1 $target/"\' /etc/hosts

virsh shutdown $target


# rm /etc/machine-id
# dbus-uuidgen --ensure=/etc/machine-id

# rm -v /etc/ssh/ssh_host_*
# dpkg-reconfigure openssh-server --default-priority

# systemctl restart sshd
