# Docker autoheal
---
**version**: 0.1.0
**author**: []
**date**: 1970-01-01

#### C01. chapter01
1. references
- https://github.com/willfarrell/docker-autoheal

2. docker run
```
docker run -d --name autoheal --restart=always \
  -e AUTOHEAL_CONTAINER_LABEL=all \
  -v /var/run/docker.sock:/var/run/docker.sock \
  willfarrell/autoheal

docker inspect --format '{{json .State.Health}}' autoheal
```
