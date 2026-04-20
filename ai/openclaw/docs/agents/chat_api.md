# OpenClaw: chat api
---
```meta
date: 1970-01-01
authors: []
version: 0.1.0
description: 
```


#### ch01. 
1. docs
- https://docs.openclaw.ai/gateway/openai-http-api

2. config
```
{
  "agents": {
    "defaults": {
      "workspace": "~/.openclaw/workspace"
    },
    "list": [
      {
        "id": "main",
        "model": {
          "primary": "deepseek/deepseek-chat",
          "fallbacks": []
        },
        "default": true
      },
      {
        "id": "agent01",
        "workspace": "/home/appuser/.openclaw/agents/agent01/workspace",
        "model": {
          "primary": "deepseek/deepseek-chat",
          "fallbacks": []
        },
        "skills": []
     }
    ]
  }
  "gateway": {
    "http": {
      "endpoints": {
        "chatCompletions": { "enabled": true },
        "responses": { "enabled": true }
      }
    }
  }
}
```

3. tests
```
token=$(jq -r .gateway.auth.token openclaw.json)

curl -i -X POST http://127.0.0.1:18789/v1/responses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $token" \
  -d '{
    "model": "openclaw/default",
    "input": "用一句话介绍 OpenClaw 是什么。"
  }'

time curl -i -X POST http://127.0.0.1:18789/v1/responses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $token" \
  -d '{
    "user": "user01",
    "model": "openclaw/agent01",
    "input": "写一个笑话"
  }'
```
