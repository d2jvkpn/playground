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
- https://www.youtube.com/watch?v=2ZZCyHzo9as
- https://www.youtube.com/watch?v=O9b8tLXCTYU

2. commands
- npm install -g openclaw@latest
- openclaw onboard --install-daemon
- openclaw onboard
- openclaw security audit --deep
- openclaw security audit --fix

- openclaw gateway status
- openclaw channels add
- openclaw configure
- openclaw config set agents.defaults.model.primary '"openai-codex/gpt-5.2"' --strict-json

- systemctl --user daemon-reload
- systemctl --user status openclaw-gateway.service

3. linux
- xdotool
- pyautogui

4. files
- /home/ubuntu/.config/systemd/user/openclaw-gateway.service

5. skills
- location: ~/.openclaw/skills/

6. feishu
```
{
  "channels": {
    "feishu": {
      "enabled": true,
      "connectionMode": "websocket",
      "dmPolicy": "pairing",
      "accounts": {
        "main": {
          "appId": "cli_xxx",
          "appSecret": "your_app_secret",
          "botName": "OpenClaw"
        }
      }
    }
  }
}
```
