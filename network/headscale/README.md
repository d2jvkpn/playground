# Title
---


#### I. 
1. docs
- https://github.com/juanfont/headscale


2. config
```
mkdir -p configs

curl -fL \
  https://raw.githubusercontent.com/juanfont/headscale/v0.29.6/config-example.yaml \
  -o configs/headscale.yaml
```

```yaml headscale.yaml
server_url: https://hs.example.com

listen_addr: 0.0.0.0:8080

database:
  type: sqlite
  sqlite:
    path: /var/lib/headscale/db.sqlite

dns:
  magic_dns: true
  base_domain: tail.example.com
```
