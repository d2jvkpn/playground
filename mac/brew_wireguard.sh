#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd -P)

## wireguard
brew install wireguard-tools

exit
brew uninstall wireguard-tools
brew autoremove

chmod 600 /etc/wireguard/wg0.conf
chown root:wheel /etc/wireguard/wg0.conf

cat > /Library/LaunchDaemons/com.wireguard.wg0.plist <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.wireguard.wg0</string>

    <key>ProgramArguments</key>
    <array>
        <string>/opt/homebrew/bin/wg-quick</string>
        <string>up</string>
        <string>wg0</string>
    </array>

    <key>RunAtLoad</key>
    <true/>

    <key>StandardOutPath</key>
    <string>/var/log/wireguard-wg0.log</string>

    <key>StandardErrorPath</key>
    <string>/var/log/wireguard-wg0.err</string>
</dict>
</plist>
EOF

sudo /usr/sbin/chown root:wheel /Library/LaunchDaemons/com.wireguard.wg0.plist
sudo chmod 644 /Library/LaunchDaemons/com.wireguard.wg0.plist

sudo launchctl bootstrap system /Library/LaunchDaemons/com.wireguard.wg0.plist

wg-quick up wg0
