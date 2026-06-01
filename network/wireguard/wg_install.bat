
wireguard /installtunnelservice C:\Users\Admin\Documents\wireguard\wg0.conf

wireguard /uninstalltunnelservice wg0


#https://download.wireguard.com/windows-client

Start-Service "WireGuardTunnel$wg0"
sc start WireGuardTunnel$wg0
Stop-Service "WireGuardTunnel$wg0"
& "C:\Program Files\WireGuard\wireguard.exe" /uninstalltunnelservice wg0
