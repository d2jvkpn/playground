#!/bin/bash
set -eu -o pipefail


mkdir -p /run/sshd /etc/ssh/sshd_config.d/keys

if [ ! -f /etc/ssh/sshd_config.d/keys/ssh_host_ed25519_key ]; then
    mkdir -p /tmp/etc/ssh
    ssh-keygen -A -f /tmp/
    mv /tmp/etc/ssh/* /etc/ssh/sshd_config.d/keys/
    rm -rf /tmp/etc
fi

if [ ! -f /etc/ssh/sshd_config.d/container-ssh.conf ]; then
cat > /etc/ssh/sshd_config.d/container-ssh.conf <<'EOF'
HostKey /etc/ssh/sshd_config.d/keys/ssh_host_rsa_key
HostKey /etc/ssh/sshd_config.d/keys/ssh_host_ecdsa_key
HostKey /etc/ssh/sshd_config.d/keys/ssh_host_ed25519_key

PubkeyAuthentication yes
KbdInteractiveAuthentication no
ChallengeResponseAuthentication no
PermitEmptyPasswords no
PermitRootLogin prohibit-password

#PasswordAuthentication no

#ListenAddress 127.0.0.1
#ListenAddress 10.1.1.5
EOF
fi

sshd -t
exec /usr/sbin/sshd -D -e
