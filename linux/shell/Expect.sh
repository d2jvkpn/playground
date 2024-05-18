#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

function display_usage() {
>&2 cat <<'EOF'
Usage of Expect.sh:

help:
  ./Expect.sh [help | -h | --help]

run:
  ./Expect.sh <field> [configs/expect.yaml]

expect.yaml fields: command, password, prompt
EOF
}

if [[ $# -eq 0 || "$1" == "help" || "$1" == "-h" || "$1" == "--help" ]]; then
    display_usage
    exit 1
fi

####
field=${1}
[[ "$field" != "."* ]] && field=".$field"

yaml=${2:-configs/expect.yaml}
[ ! -s $yaml ] && { >&2 echo "file not exists: $yaml"; exit 1; }

echo "==> config field: $yaml::${field#.}"

####
command=$(yq "$field.command" $yaml)
password=$(yq "$field.password" $yaml)
prompt=$(yq "$field.prompt" $yaml)

[[ "$command" == "null" ]] && { >&2 echo "command is unset"; exit 1; }
[[ "$password" == "null" ]] && { >&2 echo "password is unset"; exit 1; }
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
