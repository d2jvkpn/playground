# Title
---
```meta
date: 1970-01-01
authors: []
version: 0.1.0
description: 
```

## Docs
- https://tailscale.com
- https://github.com/tailscale/tailscale
- https://tailscale.com/pricing

## Installation
```
curl -fsSL https://tailscale.com/install.sh | sh

ifconfig tailscale
tailscale ip -4

tailscale status
tailscale netcheck
tailscale ping 100.x.x.x

# ??
tailscale up --adertise-routes=192.168.10.0/24
tailscale up --ssh

# 阻止其他节点访问本机
sudo tailscale set --shields-up

# 恢复其他节点访问本机
sudo tailscale set --shields-up=false
```

## headscale
- headscale: https://github.com/juanfont/headscale

- ```
mkdir -p configs
curl -o configs/headscale.yaml https://raw.githubusercontent.com/juanfont/headscale/v0.29.3/config-example.yaml
```
