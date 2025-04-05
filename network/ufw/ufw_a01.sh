#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


exit

#### 1.
sudo ufw default deny incoming
sudo ufw default allow outgoing

sudo ufw enable


#### 2.
sudo ufw allow from IP-XX to any port 51820 proto udp


#### 3.
sudo ufw deny 8080
sudo ufw allow from 192.168.1.0/24 to any port 8080


#### 4.
sudo ufw allow from 127.0.0.1 to any port 8080

sudo ufw status numbered


#### 5.
nc -zv IP-XX 8080

sudo ufw allow from 10.0.0.0/24 to any port 8080

sudo ufw deny from any to any port 8080


#### 6.
sudo ufw deny ssh


sudo ufw delete 2


#### 7.
sudo ufw logging on

ls /var/log/ufw.log
