#!/usr/bin/env bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

exit

firewall-cmd --permanent --zone=public --add-rich-rule='
  rule family="ipv4"
  source address="1.2.3.4/32"
  port protocol="tcp" port="4567" accept'

firewall-cmd --new-zone=special --permanent
firewall-cmd --reload
firewall-cmd --zone=special --add-source=192.0.2.4/32
firewall-cmd --zone=special --add-port=4567/tcp
