# Title
---
```meta
date: 1970-01-01
authors: []
version: 0.1.0
```


#### ch01. 
1. docs
- https://github.com/apernet/hysteria
- https://v2.hysteria.network
- https://v2.hysteria.network/docs/advanced/Full-Client-Config/

2. ports
- 443
- 8443
- 2083
- 2087
- 2096
- 2053

#### ch02. TODO
1. hysteria2 TUN mode
- hysteria client --tun
- client
```
tun:
  enable: true
  stack: system
```

2. sing-box TUN mode
- sing-box client
```json
{
  "inbounds": [
    {
      "type": "tun",
      "tag": "tun-in",
      "interface_name": "singtun0",
      "inet4_address": "10.10.0.2/24",
      "auto_route": true,
      "strict_route": true,
      "stack": "system"
    }
  ]
}

{
  "inbounds": [
    {
      "type": "tun",
      "tag": "tun-in",
      "interface_name": "singtun0",
      "inet4_address": "10.10.0.2/24",
      "auto_route": true,
      "strict_route": true,
      "stack": "system"
    }
  ]
}

{
  "route": {
    "rules": [
      {
        "action": "route",
        "outbound": "hy2-out"
      }
    ]
  }
}
```

- wireguard
```yaml
[Peer]
Endpoint = 10.10.0.1:51820
MTU = 1280
```
