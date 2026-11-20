# Title
---
```meta
date: 1970-01-01
authors: []
version: 0.1.0
description: 
```


## Installation
```
curl -fsSL https://tailscale.com/install.sh | sh

tailscale status
tailscale ip -4

ifconfig tailscale

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
