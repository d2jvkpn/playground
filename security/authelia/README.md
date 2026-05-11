# Authelia
---
```meta
date: 1970-01-01
authors: []
version: 0.1.0
description: 
```


#### ch01. 
1. docs
- https://github.com/authelia/authelia
- https://github.com/authelia/authelia/tree/master/examples/compose/local

2. commands
```
docker run --rm authelia/authelia:latest \
  authelia crypto hash generate argon2 --password 'your_password'

docker run --rm -v $PWD/configs/authelia:/config authelia/authelia:latest authelia config validate --config /config/configuration.yml
```
