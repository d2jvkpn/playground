### Install Virtual Machines
---

#### 1. Install KVM
```bash
grep -Eoc '(vmx|svm)' /proc/cpuinfo

sudo apt install qemu-system-x86 libvirt-daemon-system libvirt-clients bridge-utils virtinst virt-manager

systemctl is-active libvirtd
usermod -aG libvirt $USER && usermod -aG kvm $USER

brctl show
```

#### 2. Create Virtual Machine
```bash
target=ubuntu

virt-install --name=$target \
  --os-variant=generic --vcpus=2 --memory=2048 \
  --disk path=/var/lib/libvirt/images/$target.qcow2,size=30 \
  --cdrom=~/Work/kvm/ubuntu-24.04-live-server-amd64.iso
```

#### 3. Ubuntu Installation UI
- Mirror address: http://cn.archive.ubuntu.com/ubuntu
- Install openssh-server
- Username: ubuntu, Hostname: node

#### 4. Config Virtual Machine
```bash
# username=ubuntu; target=ubuntu

virsh start $target
virsh net-list
virsh net-dhcp-leases default
# rm /var/lib/libvirt/dnsmasq/virbr0.*

addr=$(virsh domifaddr $target | awk '$1!=""{split($NF, a, "/"); addr=a[1]} END{print addr}')
ssh-keygen -f ~/.ssh/known_hosts -R "$addr"
ssh -o "StrictHostKeyChecking no" ubuntu@$addr

# bash ubuntu_config.sh $target
```

#### 6. Config SSH Access from Host
```bash
target=ubuntu; username=ubuntu

KVM_SSH_Dir=${KVM_SSH_Dir:-$HOME/.ssh/kvm}
ssh_key="$KVM_SSH_Dir/kvm.pem"

mkdir -p $KVM_SSH_Dir
chmod 700 $KVM_SSH_Dir

if [ ! -f $ssh_key ]; then
    ssh-keygen -t rsa -m PEM -b 2048 -P "" -f $ssh_key -C "key for kvm"
    ssh-keygen -y -f $ssh_key > $ssh_key.pub
    chmod 0400 $ssh_key
fi

addr=$(virsh domifaddr $target | awk '$1!=""{split($NF, a, "/"); addr=a[1]} END{print addr}')

bash virsh_fix_ip.sh $target

ssh-keygen -F $addr || ssh-keyscan -H $addr >> ~/.ssh/known_hosts

record="Include ${HOME}/.ssh/kvm/*.conf"
[ -z "$(grep -c "$record" ~/.ssh/config)" ] && sed -i "1i $record" ~/.ssh/config

cat > $KVM_SSH_Dir/$target.conf << EOF
Host $target
    HostName      $addr
    User          $username
    Port          22
    LogLevel      INFO
    Compression   yes
    IdentityFile  $ssh_key
EOF

# must todo
ssh-copy-id -i $ssh_key $target
# ssh $target

scp ubuntu_config.sh $target:
ssh -t $target sudo ./ubuntu_config.sh ubuntu

virsh shutdown $target
```

#### 7. Clone VM
```bash
bash virsh_clone.sh ubuntu node01 node02 node03
```
