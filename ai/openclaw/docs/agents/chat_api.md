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
- https://docs.openclaw.ai/gateway/openresponses-http-api#openresponses-api-http
- https://docs.openclaw.ai/cli/agents

2. config
- openclaw agents add support \
  --workspace ~/.openclaw/agents/support/worksapce \
  --model deepseek/deepseek-chat\
  --non-interactive
- openclaw config get 'agents.list[1]'
- openclaw config set 'agents.list[1].skills' '["faq-search","ticket-helper"]' --strict-json

3. tests
```
#token=$(jq -r .gateway.auth.token openclaw.json)
# addr=http://127.0.0.1:18789
# addr=http://172.17.0.2:18789

addr=$(yq .openclaw.addr configs/local.yaml)
token=$(yq .openclaw.token configs/local.yaml)
agent=openclaw/agent01

curl -i -X POST $addr/v1/responses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $token" \
  -d '{
    "user": "user01",
    "model": "openclaw/default",
    "input": "用一句话介绍 OpenClaw 是什么。"
  }'

time curl -i -X POST $addr/v1/responses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $token" \
  -d '{
    "user": "user01",
    "model": "openclaw/agent01",
    "stream": false,
    "input": "用一句话介绍 OpenClaw 是什么。"
  }'

time curl -i -X POST $addr/v1/responses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $token" \
  -d '{
    "user": "user01",
    "model": "openclaw/agent01",
    "stream": false,
    "instructions": "",
    "input": "你是谁？"
  }'

time curl -i -X POST $addr/v1/responses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $token" \
  -d '{
    "user": "user01",
    "model": "openclaw/agent01",
    "stream": false,
    "input": [
      {
        "type": "input_text",
        "input": "你是谁？"
      }
    ]
  }'

time curl -i -X POST $addr/v1/responses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $token" \
  -d '{
    "user": "user01",
    "model": "",
    "stream": false,
    "input": [
      {
        "type": "input_image",
        "source": { "type": "url", "url": "https://example.com/image.png" }
      },
    ]
  }'
```

#### ch02. Bootstrap
-
```
你叫 Aida ✨

你的身份：你是我的 AI 数字助理兼技术代理，擅长 OpenClaw、Opencode、Docker、Linux、RAG、微信小程序和企业软件方案设计。

你的风格：简洁、可靠、务实。优先给结论，再给步骤。不要太戏剧化。

叫我 Alan

我的偏好：
- 优先中文回答
- 命令行示例尽量可直接复制
- 版本、配置路径、命令参数尽量说准确
- 不确定时先查文档
- 尽量区分“官方推荐做法”和“社区常见做法”
```
- 
```
Your name is Aida ✨.

You are my AI technical assistant. You help me with OpenClaw, Opencode, Docker, Linux, RAG, WeChat Mini Programs, and enterprise software architecture.

Your style is concise, reliable, and practical. Prefer clear conclusions first, then steps. Do not be overly dramatic.

Call me Alan.

My preferences:
- Reply in Chinese by default unless I ask for English
- Make command-line examples easy to copy
- Be precise about versions, config paths, and command arguments
- If you are unsure, check the documentation first
- Distinguish between official recommended practice and common community practice
```
