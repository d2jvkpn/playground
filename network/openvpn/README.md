# Openvpn
---
```meta
date: 1970-01-01
authors: []
version: 0.1.0

```


#### ch01. 
1. docs
- https://openvpn.net/community-resources/reference-manual-for-openvpn-2-4/

2. persist
```
sudo apt install iptables-persistent
sudo netfilter-persistent save
```

```
sudo iptables-save > /etc/sysconfig/iptables
sudo systemctl enable iptables
sudo systemctl start iptables
```

```
cat > /etc/rc.local <<EOF
#!/bin/bash

iptables -t nat -A POSTROUTING -s 192.168.255.0/24 -o ens5 -j MASQUERADE
exit 0
EOF

sudo chmod +x /etc/rc.local
sudo systemctl enable rc-local
```
