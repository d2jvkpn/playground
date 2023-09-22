### Title
---

#### chapter 1
- https://hub.docker.com/r/foxcpp/maddy
- command
```bash
docker volume create maddydata

docker run \
  --name maddy \
  -e MADDY_HOSTNAME=mx.maddy.test \
  -e MADDY_DOMAIN=maddy.test \
  -v maddydata:/data \
  -p 25:25 \
  -p 143:143 \
  -p 587:587 \
  -p 993:993 \
  foxcpp/maddy:latest
```
