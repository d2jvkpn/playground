#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit
mysql_config_editor set --login-path=<name> \
  --user=<user> \
  --host=<ip> \
  --password

MYSQL_TEST_LOGIN_FILE=~/.mylogin.cnf
mysql --login-path=<name>

mysql --login-path=<name> <dbname>

mysql --login-path=<name> <dbname> < import.sql
