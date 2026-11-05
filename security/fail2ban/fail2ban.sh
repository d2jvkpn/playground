#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd -P)


sudo apt install -y fail2ban

sudo systemctl enable --now fail2ban
sudo systemctl status fail2ban


cat > /etc/fail2ban/jail.d/sshd.local <<EOF
[sshd]
enabled = true
port = ssh
#port = 2222
filter = sshd
backend = systemd

maxretry = 5
findtime = 10m
bantime = 24h

banaction = nftables-multiport

#bantime.increment = true
#bantime.factor = 2
#bantime.maxtime = 1w
EOF

sudo fail2ban-client -t
sudo systemctl restart fail2ban

sudo fail2ban-client status
sudo fail2ban-client status sshd
