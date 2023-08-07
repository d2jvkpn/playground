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
  --cdrom=~/kvm/ubuntu-22.04.1-live-server-amd64.iso
```

#### 3. Ubuntu Installation UI
- Mirror address: http://cn.archive.ubuntu.com/ubuntu
- Install openssh-server
- Username: ubuntu, Hostname: node

#### 4. Config Virtual Machine
```bash
# username: ubuntu

virsh start $target
virsh net-list
virsh net-dhcp-leases default
# rm /var/lib/libvirt/dnsmasq/virbr0.*

addr=$(virsh domifaddr $target | awk '$1!=""{split($NF, a, "/"); addr=a[1]} END{print addr}')
ssh ubuntu@$addr

bash scripts/vm_config.sh
```

#### 6. Config SSH Access from Host
```bash
target=ubuntu; user=ubuntu

if [ ! -f ~/.ssh/kvm.pem ]; then
    ssh-keygen -t rsa -m PEM -b 2048 -P "" -f ~/.ssh/kvm.pem -C 'ubuntu'
    chmod 0600 ~/.ssh/kvm.pem
fi

addr=$(virsh domifaddr $target | awk '$1!=""{split($NF, a, "/"); addr=a[1]} END{print addr}')

bash scripts/virsh_fix_ip.sh $target

sshkeygen -F $addr || ssh-keyscan -H $addr >> ~/.ssh/known_hosts

cat >> ~/.ssh/config << EOF
Host $target
    HostName      $addr
    User          ubuntu
    Port          22
    LogLevel      INFO
    Compression   yes
    IdentityFile  ~/.ssh/kvm.pem
EOF

# must todo
ssh-copy-id -i ~/.ssh/kvm.pem $target
# ssh $target

virsh shutdown $target
```

#### 7. Archive OS
```bash
virt-clone --original ubuntu --name ubuntu --file ubuntu-node.$(date +'%F').qcow2

virt-install --name ubuntu --import \
  --memory 2048 --vcpus 2 --disk /var/lib/libvirt/images/ubuntu-node.$(date +'%F').qcow2,bus=sata \
  --os-variant=generic --network default \
  --nograph
```

#### 8. Clone VM
```bash
bash scripts/virsh_clone.sh ubuntu node01 ubuntu

bash scripts/virsh_clone.sh ubuntu node02 ubuntu

bash scripts/virsh_clone.sh ubuntu node03 ubuntu
```
