# Title
---


#### 1. 
1. redsocks
base {
    log_debug = off;
    log_info = on;
    daemon = on;
    redirector = iptables;
}

redsocks {
    local_ip = 127.0.0.1;
    local_port = 12345;

    ip = 192.168.1.100;
    port = 1080;
    type = socks5;
}

2. iptables
```
sudo iptables -t nat -N DOCKER_PROXY

# 排除局域网和保留地址
sudo iptables -t nat -A DOCKER_PROXY \
  -d 192.168.0.0/16 -j RETURN

sudo iptables -t nat -A DOCKER_PROXY \
  -d 172.16.0.0/12 -j RETURN

sudo iptables -t nat -A DOCKER_PROXY \
  -d 10.0.0.0/8 -j RETURN

# 其余 TCP 流量重定向
sudo iptables -t nat -A DOCKER_PROXY \
  -p tcp -j REDIRECT --to-ports 12345

# 仅拦截指定 Docker 网段
sudo iptables -t nat -I PREROUTING 1 \
  -s 172.18.0.0/16 -p tcp \
  -j DOCKER_PROXY
```
