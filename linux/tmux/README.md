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
- switch panes: ←/↑/→/↓
- detach a session: d
- resize a pane: alt + ←/↑/→/↓
- resize a pane command: resize-pane -L/-R/-U/-D 10
- command mode: Ctrl + b + :

4. window shortcuts
- create a new window: c
- switch to the previous window: p
- switch to the next window: n
- switch to window with index: 0/1/2/3
