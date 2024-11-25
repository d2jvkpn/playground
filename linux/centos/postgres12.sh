#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

# https://computingforgeeks.com/how-to-install-postgresql-12-on-centos-7/
# centos 7

# 1. Add PostgreSQL Yum Repository
sudo yum -y install https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm

# You can get more information on installed package by running the command:
rpm -qi pgdg-redhat-repo

# 2. Install PostgreSQL 12
# Disable the built-in PostgreSQL module
sudo dnf -qy module disable postgresql

sudo yum -y install epel-release yum-utils
sudo yum-config-manager --enable pgdg12
sudo yum install postgresql12-server postgresql12

# 3. Initialize and start database service
sudo /usr/pgsql-12/bin/postgresql-12-setup initdb

sudo systemctl enable --now postgresql-12


# 4. Set PostgreSQL admin user’s password

# 5. Enable remote access (Optional)
sudo firewall-cmd --add-service=postgresql --permanent
sudo firewall-cmd --reload
