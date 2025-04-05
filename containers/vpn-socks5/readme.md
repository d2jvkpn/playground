# Title
---
```meta
version: 0.1.0
authors: ["Jane Doe<jane.doe@noreply.local>"]
date: 1970-01-01
```


#### Ch01. 
1. links
- https://hub.docker.com/r/linuxserver/wireguard
- https://github.com/wg-easy/wg-easy

2. run
```wireguard
docker run -d --name vpn-socks5 -p 1200:1080 \
  --cap-add=NET_ADMIN \
  -e TZ=Etc/UTC \
  --sysctl="net.ipv4.conf.all.src_valid_mark=1" \
  --sysctl="net.ipv4.ip_forward=1" \
  local/vpn-socks5:dev tail -f /etc/hosts

# --cap-add=SYS_MODULE `#optional`
# -v /lib/modules:/lib/modules `#optional`

docker run -d --name vpn-socks5 -p 1200:1080 \
  --cap-add=NET_ADMIN --sysctl="net.ipv4.conf.all.src_valid_mark=1"
  -e TZ=Asia/Shanghai local/vpn-socks5:dev tail -f /etc/hosts
```
