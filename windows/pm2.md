# pm2
---
```meta
date: 1970-01-01
authors: []
version: 0.1.0
description: 
```


#### ch01. 
1. docs
- https://github.com/unitech/pm2

2. run
- pm2 start "C:\apps\ue\ue.exe" --name ue --cwd "C:\apps\ue" -- --port 8080
  pm2 restart ue --cron-restart="0 3 * * *"
  pm2 save
- ecosystem.config.js
```
module.exports = {
  apps: [
    {
      name: "ue",
      script: "C:\\apps\\ue\\ue.exe",
      cwd: "C:\\apps\\ue",
      args: "--port 8080",
      cron_restart: "0 3 * * *",
      autorestart: true
    }
  ]
}
```
- pm2 start ecosystem.config.js
  pm2 save
- --no-autorestart --restart-delay=10000
