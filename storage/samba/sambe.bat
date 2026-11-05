rem 清除网络连接
net use \\192.168.1.100 /delete /yes

rem 打开凭证管理
cmdkey /list

rem 目录连接
\\192.168.1.100\Public\ShareDocs

rem 命令连接
net use <Disk>: \\192.168.1.100\<SharePath> /user:<username> <password>
net use \\192.168.1.100\<SharePath> /user:<username> <password>

net use Z: \\192.168.1.100\Public\ShareDocs /user:smbuser password123
net use Z: \\192.168.1.100\Share

rem 添加凭证
cmdkey /add:192.168.1.100 /user:smbuser /pass:MyPassword123

rem 防止 Windows 自动重连
net use /persistent:no
