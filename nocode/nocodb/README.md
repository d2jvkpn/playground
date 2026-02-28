# Title
---
```meta
date: 1970-01-01
authors: []
version: 0.1.0
```


#### ch01. 
1. docs
- https://nocodb.com/
- https://github.com/nocodb/nocodb
- https://hub.docker.com/r/nocodb/nocodb/tags

2. run
```
mkdir -p data/nocodb

docker run -d --name noco -p 8080:8080 -v "$(pwd)"/data/nocodb:/usr/app/data/ nocodb/nocodb:latest

docker run -d --name noco -p 8080:8080 -v "$(pwd)"/data/nocodb:/usr/app/data/ \
  -e NC_DB="pg://host.docker.internal:5432?u=root&p=password&d=d1" \
  -e NC_AUTH_JWT_SECRET="569a1821-0a93-45e8-87ab-eb857f20a010" \
  nocodb/nocodb:latest
```
