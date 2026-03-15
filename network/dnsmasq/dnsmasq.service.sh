#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


sudo apt install -y dnsmasq

exit
#### 1. config resolved
sudo mkdir -p /etc/systemd/resolved.conf.d
cat > /etc/systemd/resolved.conf.d/dnsmasq.conf <<EOF
[Resolve]
DNS=127.0.0.1
Domains=~.
EOF

sudo systemctl restart systemd-resolved

#### 2. config dnsmasq
cat > /etc/dnsmasq.d/dnsmasq-1000.conf <<EOF
no-resolv
# cloudflare
server=1.1.1.1
# google
server=8.8.8.8

# home.arpa, www.home.arpa, api.home.arpa, x.y.home.arpa -> 192.168.1.10
address=/home.arpa/192.168.1.10

# openclaw.home.arpa -> 192.168.1.10
host-record=openclaw.home.arpa,192.168.1.10

# extra hosts
addn-hosts=/etc/dnsmasq.d/hosts

# chat.home.arpa -> openclaw.home.arpa
cname=chat.home.arpa,openclaw.home.arpa
EOF

sudo dnsmasq --test
sudo systemctl restart dnsmasq

### 3. test
dig @127.0.0.1 openclaw.home.arpa
dig @8.8.8.8 openclaw.home.arpa

dig @127.0.0.1 grafana.home.arpa
