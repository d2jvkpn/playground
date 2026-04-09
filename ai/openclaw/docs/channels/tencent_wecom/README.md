# OpenClaw Channel: tencent wecom
---
```meta
date: 1970-01-01
authors: []
version: 0.1.0
```


#### ch01. 
1. docs
- https://work.weixin.qq.com/nl/index/openclaw
- https://www.npmjs.com/package/@wecom/wecom-openclaw-plugin
- https://open.work.weixin.qq.com/help2/pc/21668
- OpenClaw如何接入企业微信智能机器人 https://open.work.weixin.qq.com/help2/pc/cat?doc_id=21657

2. installation
- Automatically install the channel plugin and quickly complete configuration; also works for updates
  * npx -y @wecom/wecom-openclaw-cli install
- If installation fails, try force install
  - npx -y @wecom/wecom-openclaw-cli install --force
- Use --help to learn more about the tool
  * npx -y @wecom/wecom-openclaw-cli --help
- Manual Install
  * openclaw plugins install @wecom/wecom-openclaw-plugin

3. config
- Interactive Setup
  * openclaw channels add
- Option 2: CLI Quick Setup
  * openclaw config set channels.wecom.botId <YOUR_BOT_ID>
  * openclaw config set channels.wecom.secret <YOUR_BOT_SECRET>
  * openclaw config set channels.wecom.enabled true
  * openclaw gateway restart
- single account
```json
{
  "plugins": {
    "entries": {
      "wecom-openclaw-plugin": {
        "enabled": true
      }
    },
    "installs": {
      "wecom-openclaw-plugin": {
        "source": "npm",
        "spec": "@wecom/wecom-openclaw-plugin@latest",
        "installPath": "/home/appuser/.openclaw/extensions/wecom-openclaw-plugin",
        "etc": "..."
      }
    },
    "allow": [
      "wecom-openclaw-plugin"
    ]
  },
  "channels": {
    "wecom": {
      "enabled": true,
      "botId": "xxxx",
      "secret": "yyyy"
    }
  },
  "tools": {
    "alsoAllow": [
      "wecom_mcp"
    ]
  }
}
```
- multi-accounts
```
{
  "channels": {
    "wecom": {
      "enabled": true,
      "defaultAccount": "default",
      "accounts": {
        "default": {
          "name": "employee-1",
          "botId": "xxxx",
          "secret": "yyyy"
        },
        "second": {
          "name": "employee-2",
          "botId": "xxxx",
          "secret": "yyyy"
        }
      }
    }
  }
}
```
- Allowlist Mode
```
{
  "channels": {
    "wecom": {
      "dmPolicy": "allowlist",
      "allowFrom": ["user_id_1", "user_id_2"]
    }
  }
}
```
  - defailt: dmPolicy=open
  - Pairing list: openclaw pairing list wecom
  - Approve Pairing: openclaw pairing approve wecom <CODE>
- bindings
```
{
  "bindings": [
    { "agentId": "your-agent", "match": { "channel": "wecom", "accountId": "main" } }
  ]
}
```
- Dynamic Agent Configuration
```
{
  "channels": {
    "wecom": {
      "dynamicAgents": {
        "enabled": true,
        "dmCreateAgent": true,
        "groupEnabled": true,
        "adminUsers": []
      }
    }
  }
}
```

