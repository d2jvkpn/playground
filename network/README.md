# Title
---
```meta
date: 1970-01-01
authors: []
version: 0.1.0
```


#### ch01. 
1. tools
- curl, wget, sshpass, expect, ansible, iftop
- lsof, socat, nmap, traceroute, bind9-dnsutils, netcat-openbsd
- iproute2, bind-tools, stunnel, iptables, ip6tables, iptables-legacy
- openssl, openssh
- openvpn, wireguard-tools, dante-server, nginx

2. proxychains
```
sudo apt install proxychains4

# /etc/proxychains.conf or ~/.proxychains/proxychains.conf:
# socks5 127.0.0.1 1080

proxychains -q psql "host=db.example.com port=5432 user=xxx dbname=yyy"

exit
ssh -N -L 15432:db.internal:5432 user@bastion
```
