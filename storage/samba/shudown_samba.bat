rem 关闭系统 Samba 服务
Stop-Service LanmanServer -Force

Get-Service LanmanServer

Set-Service LanmanServer -StartupType Disabled

Get-NetTCPConnection -LocalPort 445 -State Listen -ErrorAction SilentlyContinue

Get-Service LanmanServer

Get-SmbServerConfiguration |
    Select-Object EnableSMB1Protocol, EnableSMB2Protocol

Set-SmbServerConfiguration -EnableSMB2Protocol $false -Force

rem 重启电脑
Restart-Computer

rem 测试端口
Test-NetConnection 127.0.0.1 -Port 445

rem 检查 nginx 进程
Get-Process nginx
