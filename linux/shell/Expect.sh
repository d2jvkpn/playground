#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

function display_usage() {
>&2 cat <<'EOF'
Usage of Expect.sh:

help:
  ./Expect.sh [help | -h | --help]

run:
  ./Expect.sh <target> [configs/expect.yaml]

an example of configs/expect.yaml:
```yaml
postgres:
  command: psql postgres://account@localhost:5432/db?sslmode=disable
  expects:
  - { prompt: "Password for useraccount:", answer: "secret" }
```

expect script: ./configs/temp/postgres.expect
EOF
}

#### 1. check inputs
if [[ $# -eq 0 || "$1" == "help" || "$1" == "-h" || "$1" == "--help" ]]; then
    display_usage
    exit 1
fi

target=${1#.}

yaml=${2:-configs/expect.yaml}
[ ! -s $yaml ] && { >&2 echo "file not exists: $yaml"; exit 1; }

#### 2. check expect script
echo "==> read config: $yaml::${target}"

command=$(yq ".$target.command" $yaml)
[[ "$command" == "null" ]] && { >&2 echo "command is unset in $target"; exit 1; }

script=configs/temp/$target.expect
[ -s "$script" ] && { expect -f $script; exit 0; }

#### 3. generate expect script
mkdir -p configs/temp
echo "==> creating expect script: $script"

expects=$(
  yq -r ".$target.expects | @tsv" $yaml |
  awk 'BEGIN{FS="\t"} NR>1{printf "expect %s\nsend %s\\r\n\n", $1, $2}' |
  awk 'NF>0{$2="\""$2; $0=$0"\""}{print}'
)

cat > $script <<EOF
#!/bin/expect
set prompt "#"
set timeout 15

spawn ${command}

# expect "..."
# send "...\r"
$expects

interact
# expect eof
EOF

expect -f $script
