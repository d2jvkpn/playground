# Title
---
```meta
date: 1970-01-01
authors: []
version: 0.1.0
```


#### ch01. 
1. docs
- https://github.com/4km3/docker-dnsmasq
- https://hub.docker.com/r/4km3/dnsmasq/tags

2. usage
```
docker run --rm --dns=172.24.0.100 --network=dnsmasq -it alpine:3 sh

apk update
apk add bind-tools

dig +short a.local
```

3. cn
- ali: 223.5.5.5, 223.6.6.6
- tencent: 119.29.29.29, 1.12.12.12, 120.53.53.53
- bytedance: 180.184.1.1, 180.184.2.2

4. internaional
NextDNS: 45.90.28.0, 45.90.30.0

5. tests
```
dig @8.8.8.8 www.google.com
dig @1.1.1.1 www.google.com A

nslookup www.google.com 8.8.8.8

curl --resolve www.google.com:443:1.2.3.4 https://www.google.com
```
