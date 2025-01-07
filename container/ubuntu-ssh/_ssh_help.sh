#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


exit
mkdir -p /etc/ssh/ssh.$(date +%F).bk
mv /etc/ssh/ssh_host_* /etc/ssh/ssh.$(date +%F).bk/

dpkg-reconfigure openssh-server

ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ""
ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N ""
ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ""


exit
mkdir -p configs apps.local/ssh

[ -s configs/host.ssh-ed25519 ] ||
  ssh-keygen -t ed25519 -m PEM -N "" -C "ubuntu@localhost" -f configs/host.ssh-ed25519

[ -s configs/ssh.conf ] || cat > configs/ssh.conf <<EOF
Host ubuntu-ssh
    HostName      127.0.0.1
    User          root
    Port          2022
    IdentityFile  configs/host.ssh-ed25519
    UserKnownHostsFile configs/ssh.known_hosts
    LogLevel      INFO
    Compression   yes
    ServerAliveInterval 15
EOF

cat configs/host.ssh-ed25519.pub > apps.local/ssh/authorized_keys

docker exec ubuntu-ssh chown -R root:root /root/.ssh

ssh-keyscan -p 2022 -H ubuntu-ssh,127.0.0.1 > configs/ssh.known_hosts
# ssh-keygen -f "configs/ssh.known_hosts" -R "[127.0.0.1]:2022"
ssh -F configs/ssh.conf ubuntu-ssh
