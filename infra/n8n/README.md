# n8n
---
```meta
date: 1970-01-01
authors: []
version: 0.1.0
```


#### ch01. 
1. docs
- https://github.com/n8n-io/n8n
- https://docs.n8n.io/hosting/installation/docker/
- https://hub.docker.com/r/n8nio/n8n

2. run
- 
```
mkdir -p data/n8n_data data/n8n_workspace

docker run -d \
  --name n8n \
  -p 5678:5678 \
  -v ${PWD}/data/n8n_data:/home/node/.n8n \
  -v ${PWD}/data/n8n_workspace:/home/node/workspace \
  -e TZ=Asia/Shanghai \
  n8nio/n8n:stable
```

- 
```
docker volume create n8n_data

docker run -it --rm \
  --name n8n \
  -p 5678:5678 \
  -e DB_TYPE=postgresdb \
  -e DB_POSTGRESDB_DATABASE=n8n \
  -e DB_POSTGRESDB_HOST=localhost \
  -e DB_POSTGRESDB_PORT=5432 \
  -e DB_POSTGRESDB_USER=postgres \
  -e DB_POSTGRESDB_SCHEMA=public \
  -e DB_POSTGRESDB_PASSWORD=<POSTGRES_PASSWORD> \
  -e TZ=Asia/Shanghai \
  -v n8n_data:/home/node/.n8n \
  docker.n8n.io/n8nio/n8n:stable
```

3. plugins
```
mkdir -p data/n8n_custom
cd data/n8n_custom
npm install n8n-nodes-ollama

# docker -v $(pwd)/data/n8n_custom:/home/node/.n8n/custom
```

4. post installation
```
apk --no-cache update && apk --no-cache upgrade

apk --no-cache add coreutils bash yq jq gcompat python3 py3-pip gosu
  # curl tzdata openssl vim iproute2 supervisor nmap logroate openvpn openssh
  
```

5. tests
```
curl -i -X POST -H "Content-Type: application/json" \
  http://localhost:5678/webhook-test/d6d72245-7e79-49b1-8e2d-b2b7538e6144 -d '{"key": "AI泡沫"}'
```

6. version 2
```
docker run -d --name n8n -p 5678:5678 n8nio/n8n:2.0.1
```
