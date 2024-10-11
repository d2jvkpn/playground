#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

# echo "Hello, world!"

#### C01. rsyslog
systemctl status rsyslog

# apt install rsyslog
# systemctl start rsyslog
# systemctl enable rsyslog

tail -f /var/log/auth.log

#### C02. journalctl
# 1. 查看所有身份验证日志
journalctl -u systemd-logind

# 2. 查看特定用户的登录日志
journalctl | grep 'username'

# 3. 查看所有sudo相关日志
journalctl -u ssh

# 4. 查看所有SSH相关的日志
journalctl _COMM=sudo

# 5. 查看Authentication相关的日志
journalctl _SYSTEMD_UNIT=systemd-user-sessions.service

# 6. 带时间过滤的日志查看
journalctl --since "2023-10-01" --until "2023-10-31"

# 7. 持续查看实时日志
journalctl -f

# 8. 查看所有的认证日志
journalctl _COMM=sshd
# cat /var/log/secure
