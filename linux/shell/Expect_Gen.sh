#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

command="$1"
password_file="$2"
prompt="$3"

expect_file=configs/exp.exp

[ -f "$expect_file" ] && { >&2 echo '!!! '"file already exists: $expect_file"; exit 1; }

mkdir -p configs

cat > $expect_file <<EOF
#!/bin/expect
set prompt "#"
set timeout 60

set file [open "${password_file}" r]
set password [read -nonewline \$file]
close \$file

spawn ${command}

expect "${prompt}"
send "\$password\r"
interact

# expect eof
EOF

chmod a+x $expect_file
echo "==> saved expect file: $expect_file"
