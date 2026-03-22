# OpenClaw Channel: tencent weixin
---
```meta
date: 1970-01-01
authors: []
version: 0.1.0
```


#### ch01. 
1. docs
- https:// www.bilibili.com/video/BV1H8AgzWEEF
- https://www.youtube.com/watch?v=wxKHJMVyswQ

2. quick install
```
npx -y @tencent-weixin/openclaw-weixin-cli@latest install
```

```????
cd ~/.openclaw/extensions/openclaw-weixin
npm install

cd ~/.openclaw
npm install zod
```

3. manual installation
```
openclaw plugins install "@tencent-weixin/openclaw-weixin"

openclaw config set plugins.entries.openclaw-weixin.enabled true

openclaw channels login --channel openclaw-weixin
```
