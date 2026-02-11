# Title
---
```meta
date: 1970-01-01
authors: []
version: 0.1.0
```


#### ch01. 
1. docs
- https://github.com/louislam/uptime-kuma

2. run
```
docker run -d --restart=always -p 3001:3001 -v uptime-kuma:/app/data --name uptime-kuma louislam/uptime-kuma:1

#curl -o compose.yaml https://raw.githubusercontent.com/louislam/uptime-kuma/master/compose.yaml

cp compose.uptime-kuma.yaml compose.yaml

mkdir -p data/uptime-kuma
docker compose up -d
```
