# Title
---
```meta
date: 1970-01-01
authors: []
version: 0.1.0
```


#### ch01.
- name: CLI-Anything
  links:
  - https://github.com/HKUDS/CLI-Anything
- name: himalaya
  links:
  - https://github.com/pimalaya/himalaya

#### ch02.
- name: fzf
  links:
  - https://github.com/junegunn/fzf
- name: ast-grep
  links:
  - https://github.com/ast-grep
- name: bat
  links:
  - https://github.com/sharkdp/bat
- name: lazygit
  links:
  - https://github.com/jesseduffield/lazygit
- name: eza
  links:
  - https://github.com/eza-community/eza
- name: delta
  links:
  - https://github.com/dandavison/delta
- name: tokei
  links:
  - https://github.com/xampprocky/tokei
- name: xdotool
- name: pyautogui
- name: gnome-screenshot

#### ch03. rtk
- https://github.com/rtk-ai/rtk/releases/download/v0.36.0/rtk-x86_64-unknown-linux-musl.tar.gz
- curl -fL -o rtk-x86_64-unknown-linux-musl.tar.gz \
  https://github.com/rtk-ai/rtk/releases/latest/download/rtk-x86_64-unknown-linux-musl.tar.gz
- tar -xf rtk-x86_64-unknown-linux-musl.tar.gz -C ~/.local/bin/
```
rtk init --show
rtk init -g                     # Claude Code
rtk init -g --opencode          # OpenCode
rtk init -g --agent cursor      # Cursor
rtk init --agent windsurf       # Windsurf
rtk init --agent cline          # Cline / Roo Code
rtk gain                        # Summary stats
rtk discover                    # Find missed savings opportunities
rtk discover --all --since 7    # All projects, last 7 days
rtk session                     # Show RTK adoption across recent sessions

git clone https://github.com/rtk-ai/rtk rtk-ai--rtk.git
cd rtk-ai--rtk.git
openclaw plugins install ./openclaw
```

#### ch04. graphify
```
pip install graphifyy
graphify install

graphify install                       # Claude Code
graphify install --platform codex      # Codex
graphify install --platform opencode   # OpenCode
graphify install --platform claw       # OpenClaw
```
