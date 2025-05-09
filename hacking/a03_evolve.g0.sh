#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


#@CODE: 1970-01-01T00:00:00Z, g0, ATCG
#@CODE: 1970-01-01T00:00:00Z, g0, ATCG
#@CODE: 1970-01-01T00:00:00Z, g0, ATCG
#@CODE: 1970-01-01T00:00:00Z, g0, ATCG
#@CODE: 1970-01-01T00:00:00Z, g0, ATCG
#@CODE: 1970-01-01T00:00:00Z, g0, ATCG

MAX_GEN=${1:-10}  # 最大代数
self="$0"
SPECIES=$(basename "$self" | sed 's#\.g[0-9]\+\.sh$##')

gen=$(basename "$self" | grep -o "\.g[0-9]\+.sh$" | sed 's/\.g//; s/\.sh$//')
if [[ ! "$gen" =~ ^[0-9]+$ ]]; then
    >&2 echo "Unexpected generation number: {name}.g{number}.sh"
    exit 1
fi

# 模拟突变：随机替换一行注释为新的注释
function mutate() {
    at=$(date +%FT%T%:z)
    next=$((gen + 1))
    child="data/${SPECIES}/${SPECIES}.g$next.sh"

    line_num=$(grep -n "^#@CODE:" "$self" | shuf -n1 | cut -d: -f1)

    mkdir -p data/${SPECIES}
    segments=$(tr -dc "ATCG" < /dev/urandom | fold -w 12 | awk '{print $1; exit}')

    # 😈
    sed "${line_num} s|:.*|: $at, g$next, $segments|" "$self" > "$child"
    chmod +x "$child"

    echo ${child}
}

# 模拟繁殖：复制自己并生成下一代
function reproduce_and_execute() {
    if (( gen + 1 > MAX_GEN )); then
        echo "<== 🏁 Evolution of $SPECIES ends at generation $gen."
        return
    fi

    echo "==> 👶 $SPECIES generation $gen is running. I am $self."
    child=$(mutate)
    sleep $((RANDOM%3))
    echo "    🔁 $SPECIES generation $gen creates ${child}."

    if (( gen > 0 )); then
        rm $self
    fi
    ./$child $MAX_GEN # ?? running in background with &
}

reproduce_and_execute

# TODO: survive
