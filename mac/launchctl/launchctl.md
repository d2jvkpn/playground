# Launchctl
---


## 1. Create a LaunchDaemon
- reaplace __USERNAME__ with real username
- plist of colima: /Library/LaunchDaemons/com.__USERNAME__.colima.plist
- plist of caddy: /Library/LaunchDaemons/com.caddy.server.plist
- sudo /opt/homebrew/bin/caddy validate --adapter caddyfile --config /opt/homebrew/etc/caddy/Caddyfile

## 2. Setup
```
sudo chown root:wheel /Library/LaunchDaemons/com.__USERNAME__.colima.plist
sudo chmod 644 /Library/LaunchDaemons/com.__USERNAME__.colima.plist

sudo launchctl bootstrap system /Library/LaunchDaemons/com.__USERNAME__.colima.plist
```

## 3. Check
```
sudo launchctl print system/com.__USERNAME__.colima
sudo launchctl print system/com.caddy.server

colima status
docker ps

sudo launchctl list
```

## 4.
```
sudo launchctl unload /Library/LaunchDaemons/com.caddy.server.plist

sudo launchctl bootstrap system /Library/LaunchDaemons/com.caddy.server.plist

sudo launchctl kickstart -k system/com.caddy.server

sudo launchctl enable system/com.caddy.server
sudo launchctl print system/com.caddy.server
brew services stop caddy

sudo launchctl bootstrap system /Library/LaunchDaemons/com.caddy.server.plist

sudo launchctl disable system/com.caddy.server

sudo launchctl bootout system/com.caddy.server
```
