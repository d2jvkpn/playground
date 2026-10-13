#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd -P)


## gpu memory
sysctl -n iogpu.wired_limit_mb

python3 - <<'PY'
import json
import mlx.core as mx

print(json.dumps(mx.device_info(), ensure_ascii=False, indent=2))

print("active:", mx.get_active_memory() / 1024**3, "GiB")
print("peak:", mx.get_peak_memory() / 1024**3, "GiB")
print("cache:", mx.get_cache_memory() / 1024**3, "GiB")
PY

sysctl -n iogpu.wired_limit_mb=53084 # default_bytes: 55662788608
sysctl -n iogpu.wired_limit_mb=57344

## hostname

sudo scutil --set HostName new-hostname
sudo scutil --set LocalHostName new-hostname
sudo scutil --set ComputerName "New Hostname"

scutil --get HostName
scutil --get LocalHostName
scutil --get ComputerName
hostname

exit

## persist
sudo nano /Library/LaunchDaemons/com.local.gpu-memory.plist

cat <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.local.gpu-memory</string>

    <key>ProgramArguments</key>
    <array>
        <string>/usr/sbin/sysctl</string>
        <string>-w</string>
        <string>iogpu.wired_limit_mb=57344</string>
    </array>

    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOF

sudo chown root:wheel /Library/LaunchDaemons/com.local.gpu-memory.plist
sudo chmod 644 /Library/LaunchDaemons/com.local.gpu-memory.plist

sudo plutil -lint /Library/LaunchDaemons/com.local.gpu-memory.plist

sudo launchctl bootstrap system /Library/LaunchDaemons/com.local.gpu-memory.plist

sysctl iogpu.wired_limit_mb
