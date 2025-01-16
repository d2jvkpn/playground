#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

cd "${_path}"

exp_file=${1:-./configs/mysql_root.exp}
if [ -s $exp_file ]; then
    echo "==> execute existing $exp_file"
    $exp_file
    exit 0
fi

exists="false"
[ -s $exp_file ] && { exists="true"; $exp_file; }
[[ "$exists" == "true" ]] && exit 0

container=$(yq .services.mysql.container_name docker-compose.yaml)

if [ "$(docker container inspect -f '{{.State.Running}}' $container)" != "true" ]; then
    >&2 echo '!!! '"$container isn't running"
    exit 1
fi


mkdir -p configs/

cat > $exp_file <<EOF
#!/bin/expect
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

echo "==> saved $exp_file"
chmod a+x $exp_file

$exp_file

exit
[ -s configs/mysql_root.env ] || \
  echo "MYSQL_PWD=$(cat configs/mysql_root.password)" > configs/mysql_root.env

#### this is unsafe
docker exec --env-file=configs/mysql_root.env -it $container \
  bash -c 'mysql -u root -p$MYSQL_PWD'
