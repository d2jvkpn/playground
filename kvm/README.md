# Install Virtual Machines
---

#### C01. Install KVM
- https://www.linuxtechi.com/how-to-install-kvm-on-ubuntu/
```bash
grep -Eoc '(vmx|svm)' /proc/cpuinfo

sudo apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager \
  qemu-system-x86 libosinfo-bin virtinst

systemctl is-active libvirtd
usermod -aG libvirt,kvm $USER

sudo systemctl enable --now libvirtd

brctl show
```

#### C02. Create Virtual Machine
1. 
```bash
target=ubuntu

virt-install --name=$target \
  --os-variant=generic --vcpus=2 --memory=2048 \
  --disk path=/var/lib/libvirt/images/$target.qcow2,size=30 \
  --cdrom=~/Work/kvm/ubuntu-24.04-live-server-amd64.iso
```

2. Ubuntu Installation UI
- Mirror address: http://cn.archive.ubuntu.com/ubuntu
- Install openssh-server
- Username: ubuntu, Hostname: node

#### C03. Config Virtual Machine
```bash
# username=ubuntu; target=ubuntu
[ command -v ] || sudo apt install -y sshpass
ls configs/$target.password

virsh start $target
virsh net-list
virsh net-dhcp-leases default
# rm /var/lib/libvirt/dnsmasq/virbr0.*

addr=$(
  virsh domifaddr $target |
  awk '$1!=""{split($NF, a, "/"); addr=a[1]} END{print addr}'
)

ssh-keygen -f ~/.ssh/known_hosts -R "$addr"

sshpass -f configs/$target.password ssh \
  -o StrictHostKeyChecking=no $username@$addr mkdir -p apps

sshpass -f configs/$target.password rsync ubuntu_setup.sh $username@$addr:apps/

# ssh -o StrictHostKeyChecking=no $username@$addr
# bash ubuntu_setup.sh $target
```

#### C04. Config SSH Access from Host
```bash
target=ubuntu
username=ubuntu

kvm_ssh_dir=${kvm_ssh_dir:-$HOME/.ssh/kvm}
kvm_ssh_key="$kvm_ssh_dir/kvm.pem"

mkdir -p $kvm_ssh_dir && chmod 700 $kvm_ssh_dir

if [ ! -f $kvm_ssh_key ]; then
    ssh-keygen -t rsa -m PEM -b 2048 -P "" -f $kvm_ssh_key -C "key for kvm"
    ssh-keygen -y -f $kvm_ssh_key > $kvm_ssh_key.pub
    chmod 0400 $kvm_ssh_key
fi

addr=$(
  virsh domifaddr $target |
  awk '$1!=""{split($NF, a, "/"); addr=a[1]} END{print addr}'
)

bash virsh_fix_ip.sh $target

ssh-keygen -F $addr || ssh-keyscan -H $addr >> ~/.ssh/known_hosts

record="Include ${HOME}/.ssh/kvm/*.conf"
[ -z "$(grep -c "$record" ~/.ssh/config)" ] && sed -i "1i $record" ~/.ssh/config

cat > $kvm_ssh_dir/$target.conf <<EOF
Host $target
    HostName      $addr
    User          $username
    Port          22
    LogLevel      INFO
    Compression   yes
    IdentityFile  $kvm_ssh_key
EOF

# must todo
ssh-copy-id -i $kvm_ssh_key $target
# ssh $target

scp ubuntu_setup.sh $target:
ssh -t $target sudo ./apps/ubuntu_setup.sh $username

virsh shutdown $target
```

#### C05. Clone VM
```bash
bash virsh_clone.sh ubuntu node01 node02 node03
```

#### C06. TODO
1. allocate an ip from the LAN
