# registry
---
```meta
date: 2025-06-26
authors: []
version: 0.1.0
```


#### ch01. 
1. docs
- https://github.com/distribution/distribution/tree/main
- https://github.com/distribution/distribution/tree/main/cmd/registry
- https://hub.docker.com/_/registry

2. login
```
docker login registry.your.domain
```

```prompt
Username:
Password: 
```

- push/pull images
```
docker tag registry:3 registry.your.domain/registry:3
docker push registry.your.domain/registry:3
docker pull registry.your.domain/registry:3
```
- list all images
```bash
curl -X GET -u "<user>:<password>" https://registry.your.domain/v2/_catalog
```

```output
{"repositories":["aigcb","cck-n8n","registry"]}
```
- list all tags of a image
```bash
curl -X GET -u "<user>:<password>" https://registry.your.domain/v2/registry/tags/list
```
```output
{"name":"registry","tags":["3"]}
```
