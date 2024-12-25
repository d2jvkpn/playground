#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0)


mkdir target

# 1. 创建一个 SSH 证书签发密钥（CA 密钥）, 这通常由证书授权（Certificate Authority, CA）拥有。可以用类似的方法生成：
ssh-keygen -t rsa -b 4096 -f target/ca.ssh-rsa -C "root@localhost"

ls target/ca.ssh-rsa target/ca.ssh-rsa.pub

#2. 生成一对 SSH 密钥, 如果你还没有生成 SSH 密钥对，可以使用以下命令生成一对：
ssh-keygen -t rsa -b 4096 -f target/account.ssh-rsa -C "account@localhost"

ls target/account.ssh-rsa target/account.ssh-rsa.pub

# 3. 签发证书, 使用 CA 密钥签发一个 SSH 证书。这个证书将被附加到你的 SSH 公钥上。
ssh-keygen -s target/ca.ssh-rsa -I account_ssh-rsa_a01 -n account -V +52w target/account.ssh-rsa.pub

# - `-s target/ca.ssh-rsa` 指定用于签名的 CA 私钥。
# - `-I devops` 为证书分配一个标识符（可自定义）。
# - `-n account` 指定可以使用该证书访问的用户名。
# - `-V +52w` 指定证书有效期为 52 周。有效期也可以指定为其他时间，例如 `-V "20230101:20231231"` 表示从 2023年1月1日到2023年12月31日。
# - `target/account.ssh-rsa.pub` 是要签名的公钥。

# Signed user key target/account.ssh-rsa-cert.pub: id "devops" serial 0 for account valid from 2024-12-25T10:12:00 to 2025-12-24T10:13:56

cat target/account.ssh-rsa-cert.pub

# 4. 验证证书, 查看证书详细信息，并验证其有效期和其他属性
ssh-keygen -L -f target/account.ssh-rsa-cert.pub

# 5. 在服务器上设置 CA 公钥, 服务器需要信任证书签发的 CA。将 CA 的公钥添加到服务器的 `~/.ssh/authorized_keys` 文件或系统级的 `/etc/ssh/sshd_config` 文件中, 确保 SSH 服务设置正确以识别和接受这些证书

echo "TrustedUserCAKeys /path/to/ca.ssh-rsa.pub"

# 通过这些步骤，您可以生成并使用一个具有有效期的 SSH 证书，实现更安全和灵活的访问控制。同时，请记住定期轮换和更新证书以维护安全性。

# 6. 配置禁止用户修改 authorized_keys
account=$1

chown root:root /home/$account/.ssh/authorized_keys

chmod 644 /home/$account/.ssh/authorized_keys

chown root:root /home/$account/.ssh
chmod 755 /home/$account/.ssh
