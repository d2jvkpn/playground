#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname $0`)


# https://linuxize.com/post/how-to-configure-static-ip-address-on-ubuntu-20-04/

ls /sys/class/net |
  grep -v 'vir\|lo\|docker\|br-\|veth\|vxlan\|tun' |
  xargs -i ip addr show {}

exit

ip addr show $net

addr=$(ip -f inet addr show $net | awk '/inet / {print $2}')
gateway=$(ip route show default | awk '{print $3; exit}')

cat | sudo tee /etc/netplan/01-netcfg.yaml <<EOF
network:
  version: 2
  renderer: networkd
  ethernets:
    $device:
      dhcp4: no
      addresses:
      - $addr
      gateway4: 192.168.121.1
      nameservers:
        addresses: [8.8.8.8, 1.1.1.1]
EOF

sudo netplan apply
