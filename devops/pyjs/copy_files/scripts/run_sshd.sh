#!/bin/bash
set -eu -o pipefail


conf_dir=/etc/ssh/sshd_config.d

####
if [ ! -f "$conf_dir/container/ssh_host_ed25519_key" ]; then
    mkdir -p /tmp/etc/ssh "$conf_dir/container"
    ssh-keygen -A -f /tmp/
    mv /tmp/etc/ssh/* "$conf_dir/container"
    rm -rf /tmp/etc
fi

####
if [ ! -f "$conf_dir/sshd_container.conf" ]; then
cat > "$conf_dir/sshd_container.conf" <<EOF
HostKey $conf_dir/container/ssh_host_rsa_key
HostKey $conf_dir/container/ssh_host_ecdsa_key
HostKey $conf_dir/container/ssh_host_ed25519_key

PubkeyAuthentication yes
KbdInteractiveAuthentication no
ChallengeResponseAuthentication no
PermitEmptyPasswords no
PermitRootLogin prohibit-password

PasswordAuthentication no
PORT 4222

#ListenAddress 127.0.0.1
#ListenAddress 10.1.1.42
EOF
fi

# echo "appuser:<password>" | chpasswd

####
mkdir -p /run/sshd

sshd -t
exec /usr/sbin/sshd -D -e
