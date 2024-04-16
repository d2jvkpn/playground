#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

cd "${_path}"

exp=${1:-./configs/mysql_root.exp}
if [ -s $exp ]; then
    echo "==> execute existing $exp"
    $exp
    exit 0
fi

exists="false"
[ -f $exp ] && { exists="true"; $exp; }
[[ "$exists" == "true" ]] && exit 0

container=$(yq .services.mysql.container_name docker-compose.yaml)

if [ "$(docker container inspect -f '{{.State.Running}}' $container)" != "true" ]; then
    >&2 echo '!!! '"$container isn't running"
    exit 1
fi


mkdir -p configs/

cat > $exp <<EOF
#!/usr/bin/expect
set prompt "#"
set timeout 60

# set password "DontUseThisPassword"
# set username [lindex \$argv 0];
# set password [lindex \$argv 1];

set fh [open "./configs/mysql_root.password" r]
set password [read -nonewline \$fh]
close \$fh

spawn docker exec -it $container mysql -u root -p

expect "Enter password:"

send "\$password\r"
interact
# expect eof
EOF

echo "==> saved $exp"
chmod a+x $exp

$exp
