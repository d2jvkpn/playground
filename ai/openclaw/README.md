# Title
---
```meta
date: 1970-01-01
authors: []
version: 0.1.0
```

#### ch01. Setup
1. docs
- https://docs.openclaw.ai
- https://docs.openclaw.ai/gateway/configuration
- https://docs.openclaw.ai/help/environment
- https://docs.openclaw.ai/gateway/security
- https://docs.openclaw.ai/gateway/trusted-proxy-auth
- https://docs.openclaw.ai/tools/slash-commands
- https://docs.openclaw.ai/tools/skills
- https://docs.openclaw.ai/concepts/models
- OpenClaw安装+3大超实用玩法，炒股，搞情报，盘收藏夹...
  https://www.bilibili.com/video/BV1oNPCzkEqg
- OpenClaw（原Clawdbot）集成企业微信
  https://www.ctyun.cn/document/11057595/11091018
- How I Use Obsidian + Claude Code to Run My Life
  https://www.youtube.com/watch?v=6MBq1paspVU

- 🚀OpenClaw高级进阶技巧分享！模型精选策略+记忆系统优化经验+深度搜索集成+Gateway崩溃自动修复！Claude Code自动读日志修Bug重启验证
  https://www.bilibili.com/video/BV1pefHB1ENJ
- OpenClaw 史诗级升级！这波表现简直太逆天了！
  https://www.bilibili.com/video/BV1PffVB4EKo
- 实测Clawdbot彻底改变我的工作方式
  https://www.youtube.com/watch?v=daXOXSSyudM
- OpenClaw Tutorial for Beginners - Crash Course
  https://www.youtube.com/watch?v=u4ydH-QvPeg
- How To Use Clawdbot as a Beginner
  https://www.youtube.com/watch?v=NhJxxv3f7lI

2. commands
- npm install -g openclaw@latest
- curl -fsSL https://openclaw.ai/install.sh | bash

- openclaw onboard
- openclaw onboard --install-daemon

- openclaw security audit --deep
- openclaw security audit --fix

- openclaw gateway status
- openclaw gateway restart
- systemctl --user daemon-reload
- systemctl --user status openclaw-gateway.service
- ls ~/.config/systemd/user/openclaw-gateway.service

- openclaw skill list
- openclaw config
- openclaw configure
- ?? openclaw config set env '{"shellEnv":{"enabled":true,"timeoutMs":15000}}' --strict-json
- openclaw logs --follow

#### ch02. Configuration
1. set models
- openclaw models auth add
- openclaw models auth login --provider qwen-portal
- openclaw models auth login --provider openai-codex
- openclaw configure --section web
- openclaw models set openai-codex/gpt-5.4
- openclaw config set agents.defaults.model.primary '"openai-codex/gpt-5.4"' --strict-json
- openclaw config get agents.defaults.model
- openclaw models list

- openclaw config set models.providers.ollama.baseUrl "http://127.0.0.1:11434"
- openclaw config set models.providers.ollama.api "ollama"

- openclaw config set agents.defaults.models '["openai/gpt-5","google/gemini-2.5-flash","openrouter/auto"]' --strict-json
- openclaw config set agents.defaults.model.fallbacks '["google/gemini-2.5-flash","openrouter/auto"]'
- openclaw config get agents.defaults.models
- openclaw config unset 'agents.defaults.models.custom-dashscope-aliyuncs-com/qwen-plus'

2. commands
- /help
- /commands
- /restart
- /status
- /model
- /model status
- /model list
- /model <provider>/<model>

- /skill take-a-screenshot
- /new
- /bash pwd

4. plugins
- https://www.npmjs.com/package/@tencent-weixin/openclaw-weixin
- https://www.npmjs.com/package/@wecom/wecom-openclaw-plugin
- https://github.com/BytePioneer-AI/openclaw-china
- https://github.com/yanhaidao/wecom

#### ch03. Related
1. locations
- config: ~/.openclaw/openclaw.json
- location: ~/.openclaw/skills/
- workspace: ~/.openclaw/workspace/
