# Claude
---

#### 1. commands
- init
- /help: help
- /usage: token usages
- /skills
- /code-review
- /context: show context
  - System prompt: 8.8k tokens (0.9%)
  - System tools: 9.8k tokens (1.0%)
  - Memory files: 477 tokens (0.0%), **+System+./CLUADE.md**
  - Skills: 2.6k tokens (0.3%)
  - Messages: 2.4k tokens (0.3%), **+**
  - Free space: 910k tokens (94.1%), **+**
  - Autocompact buffer: 33k tokens (3.4%)
- /new, /clear
- /memory
- shortcuts: Shift+Tab, Esc, <-, ->

#### 2. Manage plugins
- /plugin marketplace add anthropics/claude-plugins-official
- /plugin marketplace update anthropics/claude-plugins-official
- claude plugin install superpowers@superpowers-marketplace
- claude plugin update codex@openai-codex
- claude plugin uninstall commercial-legal@claude-for-legal
- /plugin install playwright@claude-plugins-official
- /plugin install gopls-lsp@claude-plugins-official

#### 3. workflow
- spec
- writting-plans

#### 4. Permissions
- claude --permission-mode bypassPermissions
- - ~/.claude/settings.json
```
{
  "permissions": {
    "defaultMode": "bypassPermissions",
    "skipDangerousModePermissionPrompt": true
  }
}
```
- claude --permission-mode auto
```
{
  "permissions": {
    "defaultMode": "auto"
  },
  "askUserQuestionTimeout": "60s"
}
```

#### 5. openrouter api key
- ~/.claude/settings.json
```
{
  "env": {
    "ANTHROPIC_BASE_URL": "https://openrouter.ai/api",
    "ANTHROPIC_AUTH_TOKEN": "sk-xxxxxxxx",

    "ANTHROPIC_DEFAULT_SONNET_MODEL": "~anthropic/claude-sonnet-latest[1m]",
    "ANTHROPIC_DEFAULT_OPUS_MODEL": "~anthropic/claude-opus-latest[1m]",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "~anthropic/claude-haiku-latest",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "anthropic/claude-sonnet-latest[1m]"
  }
}
```
- using deepseek
```
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "env": {
    "ANTHROPIC_BASE_URL": "https://api.deepseek.com/anthropic",
    "ANTHROPIC_AUTH_TOKEN": "<DeepSeek API Key>",
    "ANTHROPIC_MODEL": "deepseek-v4-pro[1m]",

    "ANTHROPIC_DEFAULT_OPUS_MODEL": "deepseek-v4-pro[1m]",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "deepseek-v4-pro[1m]",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "deepseek-v4-flash",
    "CLAUDE_CODE_SUBAGENT_MODEL": "deepseek-v4-flash",
    "CLAUDE_CODE_EFFORT_LEVEL": "max"
  }
}
```


#### 5. comapaction
```
{
  "env": {
    "CLAUDE_CODE_AUTO_COMPACT_WINDOW": "180000",
    "CLAUDE_AUTOCOMPACT_PCT_OVERRIDE": "90"
  }
}
```
