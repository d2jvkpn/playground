### Install Virtual Machines
---

#### 1. Install KVM
```bash
grep -Eoc '(vmx|svm)' /proc/cpuinfo
sudo apt install cpu-checker

sudo apt install qemu-system-x86 libvirt-daemon-system libvirt-clients bridge-utils virtinst virt-manager

systemctl is-active libvirtd
usermod -aG libvirt $USER
usermod -aG kvm $USER
brctl show
```

#### 2. Create Virtual Machine
```bash
name=ubuntu

virt-install --name=$name \
  --os-variant=generic --vcpus=2 --memory=2048 \
  --disk path=/var/lib/libvirt/images/$name.qcow2,size=30 \
  --cdrom=~/kvm/ubuntu-22.04.1-live-server-amd64.iso
```

#### 3. Ubuntu Installation UI
...

#### 4. Config Virtual Machine
```bash
# username: hello

virsh start $name
virsh net-list
virsh net-dhcp-leases default
# rm /var/lib/libvirt/dnsmasq/virbr0.*

addr=$(virsh domifaddr $name | awk '$1!=""{split($NF, a, "/"); addr=a[1]} END{print addr}')
ssh hello@$addr

bash scripts/vm_config.sh
```

#### 5. Archive OS
```bash
virt-clone --original ubuntu --name ubuntu --file ubuntu.$(date +'%F').qcow2

virt-install --name ubuntu --import \
  --memory 2048 --vcpus 2 --disk /var/lib/libvirt/images/ubuntu.$(date +'%F').qcow2,bus=sata \
  --os-variant=generic --network default \
  --nograph
```

#### 6. Fix IP of Virtual Machine
```bash
bash scripts/virsh_fix_ip.sh $name
```

#### 7. Config SSH Access from Host
```bash
name=ubuntu; user=hello

ssh-keygen -t rsa -m PEM -b 2048 -P "" -f ~/.ssh/kvm.pem -C 'ubuntu'
chmod 0600 ~/.ssh/kvm.pem

addr=$(virsh domifaddr $name | awk '$1!=""{split($NF, a, "/"); addr=a[1]} END{print addr}')
ssh-keyscan -H $addr >> ~/.ssh/known_hosts

cat >> ~/.ssh/config << EOF
Host $name
    HostName      $addr
    User          hello
    Port          22
    LogLevel      INFO
    Compression   yes
    IdentityFile  ~/.ssh/kvm.pem
EOF

ssh-copy-id -i ~/.ssh/kvm.pem $name
# ssh $name
```

#### 8. Clone VM
```bash
bash scripts/virsh_clone.sh ubuntu node01 hello

bash scripts/virsh_clone.sh ubuntu node02 hello

bash scripts/virsh_clone.sh ubuntu node03 hello
```
