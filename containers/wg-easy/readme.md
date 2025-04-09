
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

2. bcrypt-tool.py
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
