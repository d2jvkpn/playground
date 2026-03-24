# OpenClaw Browser
---
```meta
date: 1970-01-01
authors: []
version: 0.1.0
```


#### ch01. 
1. headless
```
{
  browser: {
    enabled: true,
    defaultProfile: "openclaw",
    headless: true,
    noSandbox: true,
    profiles: {
      openclaw: {
        color: "#FF4500"
      }
    }
  }
}
```

2. cdp
```
{
  "browser": {
    "enabled": true,
    "defaultProfile": "browserbase",
    "remoteCdpTimeoutMs": 3000,
    "remoteCdpHandshakeTimeoutMs": 5000,
    "profiles": {
      "browserbase": {
        "attachOnly": true,
        "cdpUrl": "http://host.docker.internal:9222",
        "color": "#F97316"
      }
    }
  }
}
```

```
{
  browser: {
    enabled: true,
    defaultProfile: "browserbase",
    remoteCdpTimeoutMs: 3000,
    remoteCdpHandshakeTimeoutMs: 5000,
    profiles: {
      browserbase: {
        cdpUrl: "wss://connect.browserbase.com?apiKey=<BROWSERBASE_API_KEY>",
        color: "#F97316"
      }
    }
  }
}
```

3. chromium
apt-get update

apt-get install -y \
  libnss3 \
  libnss3-tools \
  ca-certificates

update-ca-certificates

socat TCP-LISTEN:9222,fork,reuseaddr,bind=0.0.0.0 TCP:127.0.0.1:9223

- gui
chromium \
  --headless=new \
  --remote-debugging-port=9223 \
  --user-data-dir=data/chromium
# not working: --remote-debugging-address=0.0.0.0

- docker
docker run -d \
  --name openclaw-cdp \
  -p 9222:9222 \
  ghcr.io/browserless/chromium \
  chromium --headless=new --no-sandbox \
    --remote-debugging-address=0.0.0.0 \
    --remote-debugging-port=9222 \
    --user-data-dir=/tmp/chromium

- healthz check
curl http://host.docker.internal:9222/json/version
curl http://127.0.0.1:9222/json/version

