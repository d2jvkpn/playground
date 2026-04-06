# Agentic Devbox
---
```meta
date: 1970-01-01
authors: []
version: 0.1.0
```

#### ch01. 
1. opencode, openspec, codex, gemini-cli
- https://opencode.ai
- https://opencode.ai/docs/tui
- https://github.com/anomalyco/opencode
- https://github.com/opencode-ai/opencode
- https://opencode.ai/docs/config
- https://opencode.ai/docs/cli/#environment-variables

- https://opencode.ai/docs/tools/
- https://opencode.ai/docs/rules/
- https://opencode.ai/docs/agents/
- https://opencode.ai/docs/models/
- https://opencode.ai/docs/commands/

- https://openspec.dev
- https://github.com/Fission-AI/OpenSpec

- https://openai.com/codex/
- https://github.com/openai/codex
- https://developers.openai.com/codex/guides/agents-md/
- https://github.com/google-gemini/gemini-cli

2. misc
- official image: ghcr.io/anomalyco/opencode
- config file: data/xdg/config/opencode/opencode.json
- data dir: data/xdg/share/opencode
- auth file: data/xdg/share/opencode/auth.json
- global skills: ~/.config/opencode/skills/<name>/SKILL.md
- project skills: .agents/skills/<name>/SKILL.md or .opencode/skills/<name>/SKILL.md
- agents: ~/.config/opencode/agents, ./opencode/agents

3. plugins
- oh-my-opencode, oh-my-openagent
  - link: https://github.com/code-yeongyu/oh-my-opencode, https://github.com/code-yeongyu/oh-my-openagent
  - prompt: Install and configure oh-my-opencode by following the instructions here: https://raw.githubusercontent.com/code-yeongyu/oh-my-opencode/refs/heads/master/docs/guide/installation.md
  - install: npx -y oh-my-opencode@latest install
- superpowers
  - link: https://github.com/obra/superpowers/blob/main/docs/README.opencode.md
- supermemory
  - link: https://github.com/supermemoryai/opencode-supermemory

#### ch02.
1. commands
```
opencode auth login
opencode mcp list
opencode mcp auth <server-name>
opencode mcp logout <server-name>
opencode mcp debug <server-name>
```

2. Language Server Protocol(LSP)
- https://opencode.ai/docs/lsp/
- Bash → bash-language-server
- YAML → yaml-language-server
- Python → pyright: pip install --no-cache pyright
- TypeScript / JavaScript → typescript

- Go → gopls
  - go install golang.org/x/tools/gopls
  - go install golang.org/x/tools/cmd/goimports@latest && \
  - go install honnef.co/go/tools/cmd/staticcheck@latest
- Rust → rust-analyzer, https://github.com/rust-lang/rust-analyzer/releases
- Vue → vue
```
