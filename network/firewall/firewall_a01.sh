#!/usr/bin/env bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

exit

# 1. 安装与启动
sudo apt-get install firewalld

sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo firewall-cmd --state


# 2. 基本命令
# 查看当前区域
sudo firewall-cmd --get-active-zones

# 查看区域中的规则
sudo firewall-cmd --list-all
sudo firewall-cmd --zone=public --list-all

# 3. 服务管理
# 添加服务
sudo firewall-cmd --add-service=http --permanent
sudo firewall-cmd --add-service=https --permanent
# sudo firewall-cmd --add-service=ssh --permanent

sudo firewall-cmd --reload

# 删除服务
sudo firewall-cmd --zone=public --remove-service=http
sudo firewall-cmd --reload

# 4. 端口管理
# 开放一个端口
sudo firewall-cmd --zone=public --add-port=8080/tcp
sudo firewall-cmd --runtime-to-permanent

sudo firewall-cmd --zone=public --add-port=51820/udp
sudo firewall-cmd --runtime-to-permanent

# 从区域中删除端口
sudo firewall-cmd --zone=public --remove-port=8080/tcp
sudo firewall-cmd --runtime-to-permanent
