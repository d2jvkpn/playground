# Codex
---


#### 1. commands
- /usage
- /status
- /plugins
- codex auth login
- codex login --device-auth
- /pemissions
- codex --sandbox workspace-write --ask-for-approval on-request

#### 2. plugins
- codex plugin list --json
- codex plugin marketplace upgrade <marketplace> --ref main     # git marketplaces only
- codex plugin marketplace remove <marketplace>
- codex plugin marketplace upgrade <marketplace>  # git marketplaces only
- codex plugin remove superpowers@openai-curated
- codex plugin add superpowers@openai-curated
- codex plugin marketplace add https://github.com/example/plugins.git --sparse .agents/plugins

#### 3. install
- npm install -g @openai/codex

#### 4. comapaction
~/.codex/config.toml
```
model = "gpt-5.6"

# Codex 用于计算容量的上下文窗口
model_context_window = 258400

# 达到此 token 数时自动压缩
model_auto_compact_token_limit = 220000

# total：统计整个活动上下文
model_auto_compact_token_limit_scope = "total"
```

#### 5. in container without bubblewrap
```
codex --sandbox danger-full-access --ask-for-approval on-request
```

or

```yaml ~/.codex/config.toml
sandbox_mode = "danger-full-access"
approval_policy = "on-request"
```
