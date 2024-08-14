#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

function display_usage() {
>&2 cat <<'EOF'
Usage of Expect.sh:

help:
  ./Expect.sh [help | -h | --help]

run:
  ./Expect.sh <target> arg1 agr2

an example of configs/expect.yaml or ~/.config/expect/expect.yaml:
```yaml
postgres:
  commandline: psql postgres://account@localhost:5432/db?sslmode=disable
  expects:
  - { prompt: "Password for username:", answer: "password", extra_args: "false" }
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
shift
args=$@

# yaml=${yaml:-""}
# [ -z "$yaml" ] && yaml=./configs/expect.yaml
yaml=./configs/expect.yaml; temp_dir=./configs/temp

[ -s "$yaml" ] || {
    yaml=~/.config/expect/expect.yaml;
    temp_dir=~/.config/expect/temp;
}

force=${force:-false}

[ ! -s $yaml ] && {
    >&2 echo '!!! '"files are not exists: ./configs/expect.yaml or ~/.config/expect/expect.yamk";
    exit 1;
}

#### 2. check expect script
echo "==> Read config: $yaml::${target}"

script=$temp_dir/$target.expect
[[ -s "$script" && "$force" == "false" ]] && {
    echo "==> Executing $script";
    expect -f $script $args;
    exit 0;
}

#### 3. read expects
commandline=$(yq ".$target.commandline" $yaml)
[[ "$commandline" == "null" ]] && { >&2 echo '!!! '"Commandline is unset in $target"; exit 1; }

extra_args=$(yq ".$target.extra_args" $yaml)
[[ "$extra_args" == "true" ]] && commandline="$commandline \$args"

expects=$(
  yq -r ".$target.expects | @tsv" $yaml |
  awk 'BEGIN{FS="\t"} NR>1{printf "expect %s\nsend %s\\r\n\n", $1, $2}' |
  awk 'NF>0{$2="\""$2; $0=$0"\""}{print}'
)

#### 4. generate expect
mkdir -p $temp_dir
echo "==> Creating expect: $script"

cat > $script <<EOF
#!/bin/expect
set prompt "#"
set timeout 15

# set arg1 [lindex \$argv 0]
set args [join \$argv " "]
# !!! remove \$args if extra args cause an error
spawn ${commandline}

# expect "..."
# send "...\r"
$expects

interact
# expect eof
EOF

#### 5. executing
echo "==> Executing $script";
expect -f $script $@
