# Title
---


#### 1. Installation
```
curl -fsSL https://github.com/SaladDay/cc-switch-cli/releases/latest/download/install.sh | bash
```

#### 2. Usage
```
cc-switch                                             # 进入 TUI

cc-switch --app claude provider list                  # 查看 Claude Code 的供应商
cc-switch --app claude provider current               # 查看当前供应商
cc-switch --app claude provider switch <provider-id>  # 切换供应商

cc-switch use <provider-id>                           # 简写；Claude 是默认 app

cc-switch --app codex provider list                   # Codex
cc-switch --app codex provider switch <provider-id>

cc-switch --app opencode provider list                # OpenCode

cc-switch env tools                                   # 查看本机安装了哪些 coding agents
cc-switch --app codex mcp sync                        # 同步 MCP 配置
```
