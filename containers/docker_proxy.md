# docker proxy
---


#### C01. docker pull through socks5(not socks5h)
- https://gist.github.com/alphamarket/404fb8dda86edfe204ab38719379833a
1. Create the config file
```bash
mkdir -p /etc/systemd/system/docker.service.d

cat <<EOF > /etc/systemd/system/docker.service.d/http-proxy.conf
[Service]
Environment="HTTP_PROXY=socks5://127.0.0.1:1080"
Environment="HTTPS_PROXY=socks5://127.0.0.1:1080"
Environment="NO_PROXY=example.com,127.0.0.1"
EOF
```

2. Flush changes
```bash
systemctl daemon-reload

systemctl show --property Environment docker

systemctl restart docker
```

3. test
```
docker pull alpine:3

tcpdump -i any -n port 53
```

#### C02. docker build with socks5h
TODO:
