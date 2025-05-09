#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


target=$1; username=$2

kvm_ssh_dir=${kvm_ssh_dir:-$HOME/.ssh/kvm}
kvm_ssh_key="$kvm_ssh_dir/kvm.pem"
kvm_ssh_known_hosts="$kvm_ssh_dir/kvm.known_hosts"

ls configs/$target.password > /dev/null
command -v sshpass || { >&2 echo "no sshpass installed"; exit 1; }

#### 1. setup ssh key for kvm
record="Include ${kvm_ssh_dir}/*.conf"
grep "$record" ~/.ssh/config || sed -i "1i $record" ~/.ssh/config

[ -d "$kvm_ssh_dir" ] || { mkdir -p $kvm_ssh_dir; chmod 700 $kvm_ssh_dir; }

if [ ! -s $kvm_ssh_key ]; then
    echo "==> 1.1 generating kvm ssh key: $kvm_ssh_key"
    ssh-keygen -t rsa -m PEM -b 2048 -P "" -f $kvm_ssh_key -C "key for kvm"
    ssh-keygen -y -f $kvm_ssh_key > $kvm_ssh_key.pub
    chmod 0400 $kvm_ssh_key
fi

#### 2. generate ssh config
echo "==> 2.1 creating ssh config: $kvm_ssh_dir/$target.conf"

addr=$(
  virsh domifaddr $target |
  awk 'NR>2 && $1!=""{split($NF, a, "/"); addr=a[1]} END{print addr}'
)

cat > $kvm_ssh_dir/$target.conf <<EOF
Host $target
    HostName      $addr
    User          $username
    Port          22
    LogLevel      INFO
    Compression   yes
    IdentityFile        $kvm_ssh_key
    UserKnownHostsFile  $kvm_ssh_known_hosts
EOF

ssh-keygen -f ~/.ssh/known_hosts -R "$addr"
ssh-keygen -F $addr || ssh-keyscan -H $addr >> $kvm_ssh_known_hosts
sshpass -f configs/$target.password ssh-copy-id -i $kvm_ssh_key $target

# ssh -o StrictHostKeyChecking=no $username@$addr
# ssh-copy-id -o StrictHostKeyChecking=no -i $kvm_ssh_key $target
# ssh $target

#### 3. ubuntu setup
echo "==> 3.1 ubuntu setup on $target"

rsync ubuntu_setup.sh $target:apps/
# ssh -t $target sudo bash ./ubuntu_setup.sh $username
cat configs/$target.password | ssh $target sudo -S bash ./apps/ubuntu_setup.sh $username

echo "==> 3.2 shutdown $target"
virsh shutdown $target
