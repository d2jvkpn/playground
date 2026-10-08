#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd -P)


sudo apt install git build-essential
git clone https://github.com/rvaiya/keyd.git
cd keyd
make
sudo make install
sudo systemctl enable --now keyd


sudo mkdir -p /etc/keyd

cat > /etc/keyd/default.conf <<EOF

[ids]
*

[control+alt]
r = f2
EOF


sudo keyd reload
