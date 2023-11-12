#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})
# set -x

container=$(yq .services.mysql.container_name docker-compose.yaml)

mkdir -p configs/

cat > configs/mysql.exp <<EOF
#!/usr/bin/expect
set prompt "#"
set timeout 60

# set password "DontUseThisPassword"
# set username [lindex \$argv 0];
# set password [lindex \$argv 1];

set fh [open "./configs/mysql.secret" r]
set password [read -nonewline \$fh]
close \$fh

spawn docker exec -it $container mysql -u root -p

expect "Enter password:"

send "\$password\r"
interact
# expect eof
EOF

echo "==> saved configs/mysql.exp"
chmod a+x configs/mysql.exp

./configs/mysql.exp
