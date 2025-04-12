
# Title
---
```meta
version: 0.1.0
authors: ["Jane Doe<jane.doe@noreply.local>"]
date: 1970-01-01
```


#### Ch01. 
1. docs
- https://www.wireguard.com/
- https://github.com/wg-easy/wg-easy

2. bcrypt-tool.py (path=linux/shell/bcrypt-tool.py)
```
./bcrypt-tool.py hash --cost=12 --password=123456

./bcrypt-tool.py verify --hashed='$2b$12$kWDm/l.2QiJvhqHqWUjmN.xwRp8cQqp2qwLiYxG8CDzwlyUeox0ZG' \
  --password=123456
```

3. htpasswd
```
sudo apt install apache2-utils

htpasswd -nbB "admin" "123456"
```


#### Ch02. 
docker run --rm --name wg -it \
  --cap-add=NET_ADMIN --cap-add=SYS_MODULE \
  --sysctl=net.ipv4.conf.all.src_valid_mark=1 --sysctl=net.ipv4.ip_forward=1 \
  ghcr.io/wg-easy/wg-easy:14 bash
