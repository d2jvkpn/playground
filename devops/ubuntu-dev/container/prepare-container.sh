#!/bin/sh
set -eu

hash_file=${UBUNTU_AUTH_HASH_FILE:-/run/ubuntu-auth/ubuntu.hash}
if [ -s "$hash_file" ]; then
    hash=$(cat "$hash_file")
    printf 'ubuntu:%s\n' "$hash" | chpasswd -e
else
    usermod -p '!' ubuntu
fi

mkdir -p /etc/ssh /run/sshd
for item in ssh_config ssh_config.d sshd_config sshd_config.d; do
    source="/opt/defaults/ssh/$item"
    target="/etc/ssh/$item"
    if [ -e "$source" ] && [ ! -e "$target" ] && [ ! -L "$target" ]; then
        cp -a "$source" "$target"
    fi
done

ssh-keygen -A
