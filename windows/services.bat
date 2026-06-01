# 查询
sc query "WireGuardTunnel$wg0"

# 启动
sc start "WireGuardTunnel$wg0"

# 停止
sc stop "WireGuardTunnel$wg0"

# 设置开机启动
sc config "WireGuardTunnel$wg0" start= auto

# 设置手动启动
sc config "WireGuardTunnel$wg0" start= demand

# 重新启动
Restart-Service 'WireGuardTunnel$wg0'

# 禁用
sc config "WireGuardTunnel$wg0" start= disabled

# 删除服务
sc delete "服务名"

# 图形管理
services.msc

#查看所有第三房服务
Get-CimInstance Win32_Service |
Where-Object {
    $_.PathName -and
    $_.PathName -notmatch "C:\\Windows\\System32" -and
    $_.PathName -notmatch "C:\\Windows\\SysWOW64" -and
    $_.PathName -notmatch "C:\\Windows\\servicing" -and
    $_.PathName -notmatch "C:\\Windows\\WinSxS"
} |
Select-Object Name, DisplayName, State, StartMode, PathName |
Sort-Object DisplayName

#只看开机自启的第三方服务
Get-CimInstance Win32_Service |
Where-Object {
    $_.StartMode -eq "Auto" -and
    $_.PathName -and
    $_.PathName -notmatch "C:\\Windows\\System32" -and
    $_.PathName -notmatch "C:\\Windows\\SysWOW64" -and
    $_.PathName -notmatch "C:\\Windows\\servicing" -and
    $_.PathName -notmatch "C:\\Windows\\WinSxS"
} |
Select-Object Name, DisplayName, State, StartMode, PathName |
Sort-Object DisplayName

# 查询可疑路径服务
Get-CimInstance Win32_Service |
Where-Object {
    $_.PathName -match "AppData|Downloads|Temp|Users\\.*\\Documents|ProgramData"
} |
Select-Object Name, DisplayName, State, StartMode, PathName |
Sort-Object DisplayName

# 只导出第三方服务
Get-CimInstance Win32_Service |
Where-Object {
    $_.PathName -and
    $_.PathName -notmatch "C:\\Windows\\System32" -and
    $_.PathName -notmatch "C:\\Windows\\SysWOW64" -and
    $_.PathName -notmatch "C:\\Windows\\servicing" -and
    $_.PathName -notmatch "C:\\Windows\\WinSxS"
} |
Select-Object Name, DisplayName, State, StartMode, PathName |
Sort-Object DisplayName |
Export-Csv "$env:USERPROFILE\Desktop\non-windows-services.csv" -NoTypeInformation -Encoding UTF8
