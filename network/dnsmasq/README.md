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

2. tests
```
docker run --rm --dns=172.24.0.100 --network=dnsmasq -it alpine:3 sh

apk update
apk add bind-toools

dig +short a.local
```
