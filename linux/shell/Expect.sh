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

an example of configs/expect.yaml:
```yaml
postgres:
  command: psql postgres://account@localhost:5432/db?sslmode=disable
  interactive:
  - { prompt: "Password for user account:", answer: "secret" }
```
EOF
}

if [[ $# -eq 0 || "$1" == "help" || "$1" == "-h" || "$1" == "--help" ]]; then
    display_usage
    exit 1
fi

####
field=${1#.}

yaml=${2:-configs/expect.yaml}
[ ! -s $yaml ] && { >&2 echo "file not exists: $yaml"; exit 1; }

echo "==> config field: $yaml::${field}"

####
command=$(yq ".$field.command" $yaml)
# answer=$(yq "$field.answer" $yaml)
# prompt=$(yq "$field.prompt" $yaml)

[[ "$command" == "null" ]] && { >&2 echo "command is unset"; exit 1; }

interactive=$(
  yq -r ".$field.interactive | @tsv" $yaml |
  awk 'BEGIN{FS="\t"} NR>1{printf "expect %s\nsend %s\\r\n\n", $1, $2}' |
  awk 'NF>0{$2="\""$2; $0=$0"\""}{print}'
)

mkdir -p configs/temp
script=configs/temp/$(tr -dc 'a-zA-Z0-9' </dev/random | fold -w 32 | head -n1 || true).expect

echo "==> expect file: $script"

function on_exit() {
    rm -f $script
}

# trap on_exit EXIT

####
cat > $script <<EOF
#!/bin/expect
set prompt "#"
set timeout 15

spawn ${command}

# expect "..."
# send "...\r"
$interactive

interact
# expect eof
EOF

expect -f $script
