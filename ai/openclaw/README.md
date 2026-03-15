# Title
---
```meta
date: 1970-01-01
authors: []
version: 0.1.0
```

#### ch01. 
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
- openclaw config set agents.defaults.model.primary '"openai-codex/gpt-5.2"' --strict-json

- openclaw models auth add
- openclaw models auth login --provider qwen-portal
- openclaw models auth login --provider openai-codex

- openclaw channels add
- openclaw pairing approve feishu <code>
- openclaw config unset channels.feishu
- openclaw config set channels.feishu.enabled true
- openclaw config set channels.feishu.appId "AppID"
- openclaw config set channels.feishu.appSecret "AppSecret"

- openclaw logs --follow

- openclaw agents list
- openclaw agents add bot01 \
  --workspace ~/.openclaw/bot01 \
  --agent-dir ~/.openclaw/agents/bot01 \
  --model qwen3.5-plus
  # --bind [feishu | feishu:account]
- openclaw agents set-identity --agent bot01 --name "bot01" --emoji 🤖
- openclaw agents bindings
- openclaw tui --agent bot01
- openclaw agent --agent bot01 --message "测试" --deliver

3. linux
- xdotool
- pyautogui
- gnome-screenshot

4. locations
- config: ~/.openclaw/openclaw.json
- location: ~/.openclaw/skills/
- workspace: ~/.openclaw/workspace/

5. commands
- /help
- /commands
- /restart
- /status
- /model status
- /model list
- /model <provider>/<model>

- /skill take-a-screenshot
- /new
- /bash pwd

6. related repositories
- ironclaw https://github.com/nearai/ironclaw
- nanoclaw https://github.com/qwibitai/nanoclaw
- CoPaw https://github.com/agentscope-ai/CoPaw
