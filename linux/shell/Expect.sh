#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

function display_usage() {
>&2 cat <<'EOF'
Usage of Expect.sh:

help:
  ./Expect.sh [help | -h | --help]

run:
  ./Expect.sh <expect.yaml> [field]

yaml fields: command, password, prompt
EOF
}

cmd=${1:-help}
if [[ "$cmd" == "help" || "$cmd" == "-h" || "$cmd" == "--help" ]]; then
    display_usage
    exit 1
fi

####
yaml=$1

field=${2:-"."}
[[ "$field" != "."* ]] && field=".$field"

####
command=$(yq "$field.command" $yaml)
[[ "$command" == "null" ]] && { >&2 echo "command is unset"; exit 1; }

password=$(yq "$field.password" $yaml)
[[ "$password" == "null" ]] && { >&2 echo "password is unset"; exit 1; }

prompt=$(yq "$field.prompt" $yaml)
[[ "$prompt" == "null" ]] && { >&2 echo "prompt is unset"; exit 1; }

mkdir -p configs/temp
script=configs/temp/$(tr -dc '[a-z][A-Z][0-9]' </dev/random | fold -w 32 | head -n1 || true).expect

echo "==> expect file: $script"

function on_exit() {
    rm -f $script
}

trap on_exit EXIT

####
cat > $script <<EOF
#!/bin/expect
set prompt "#"
set timeout 15

set password "$password"

spawn ${command}

expect "${prompt}"
send "\$password\r"

interact

# expect eof
EOF

expect -f $script
