#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})
# set -x

container=$(yq .services.postgres.container_name docker-compose.yaml)

cat > configs/connect.exp <<EOF
#!/usr/bin/expect
set prompt "#"
set timeout 60

# set password "DontUseThisPassword"
# set username [lindex \$argv 0];
# set password [lindex \$argv 1];

set fh [open "./configs/postgres.secret" r]
set password [read -nonewline \$fh]
close \$fh

spawn docker exec -it $container psql postgres://postgres@localhost:5432/postgres

expect "Password for user postgres:"

send "\$password\r"
interact
# expect eof
EOF

echo "==> saved configs/connect.exp"
chmod a+x configs/connect.exp

./configs/connect.exp
