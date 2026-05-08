#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


#### C01. rsyslog
systemctl status rsyslog

# apt install rsyslog
# systemctl start rsyslog
# systemctl enable rsyslog

# debian
tail -f /var/log/auth.log

# centos
tail -f /var/log/secure

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

ls \
  /var/log/syslog \
  /var/log/messages \
  /var/log/auth.log \
  /var/log/secure \
  /var/log/journal/ \
  /run/log/journal/ \
  ~/.bash_history

# 9. auditd
sudo apt-get install auditd
echo "auditctl -a always,exit -F arch=b64 -S execve -k exec_commands" >> /etc/audit/rules.d/audit.rules
ausearch -k exec_commands

# 10. ssh login fingprint
ssh-keygen -lf id_rsa.pub
head -n1 .ssh/authorized_keys | ssh-keygen -lf -

grep Accepted /var/log/secure
grep Accepted /var/log/auth.log
