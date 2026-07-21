# Tmux
---
```meta
date: 1970-01-01
authors: []
version: 0.1.0
```

#### ch01. 
1. concepts
session
  ├─ window 1
  │    ├─ pane A
  │    └─ pane B
  ├─ window 2
  │    └─ pane A
  └─ window 3
       ├─ pane A
       ├─ pane B
       └─ pane C

2. commands
- list all sessions: tmux ls
- create a new session: tmux
- create a new session: tmux new -s mywork
- attach to the last session: tmux attach
- attach to a session: tmux attach -t mywork
- kill a session: tmux kill-session -t mywork
- kill all sessions: tmux kill-server

- exit current pane: exit

3. pane shortcuts: Ctrl + b
- create a new pane: %/"
- rename current session: $
- switch panes: ←/↑/→/↓, select-pan + L/U/R/D
- detach a session: d
- resize a pane: alt + ←/↑/→/↓
- resize a pane command: resize-pane -L/-R/-U/-D 10
- command mode: Ctrl + b + :

4. window shortcuts
- create a new window: c
- switch to the previous window: p
- switch to the next window: n
- switch to window with index: 0/1/2/3

5. usage
```
- 结构: Session（会话） > Window（窗口） > Pane（面板）
- 开启一个 session: tmux new -s coding
- 恢复: tmux attach
- 恢复一个 session: tmux attach -t coding
- 列出所有 windows: tmux list-windows
- 列出所有 sessions: tmux list-sessions

- 在右侧新建一个 pane: Ctrl+B ++ %
- 在底部新建一个 pane: Ctrl+B ++ "
- 切换 panes: Ctrl+B ++ ←/↑/→/↓
- 调整 panes 的宽度: Ctrl+B+←/→
- 调整 panes 的高度: Ctrl+B+↑/↓
- 将一个 pane 转换为一个 window: Ctrl+B ++ !
- 将一个 pane 最大化到全屏/恢复面板: Ctrl+B ++ z
- 列出所有 windows: Ctrl+B ++ w
- 查找一个 window: Ctrl+B ++ f

- 新建一个 window: Ctrl+B ++ c
- 切换 windows: Ctrl+B ++ p/0/1/2/3...
- 输入命令: Ctrl+B ++ :
- detach 一个 window: Ctrl+B ++ d

- 查看终端历史
  - 进入复制模式: Ctrl+B ++ [
  - ↑/↓, PageUp/PageDown
  - 退出: q
  - 或者配置 ~/.tmux.conf "set -g mouse on"
```
