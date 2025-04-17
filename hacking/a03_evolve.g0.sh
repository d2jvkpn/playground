#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

#### MUTATION: 1970-01-01T00:00:00Z, g0, ATCG

MAX_GEN=${1:-7}    # 最大代数
ME="$0"
NAME=$(basename "$ME" | sed 's#\.g[0-9]\+\.sh$##')

GEN=$(basename "$ME" | grep -o "\.g[0-9]\+.sh$" | sed 's/\.g//; s/\.sh$//')
if [[ ! "$GEN" =~ ^[0-9]+$ ]]; then
    >&2 echo "Unexpected generation number"
    exit 1
fi

echo "==> 👶 $NAME generation $GEN is running. I am $ME"

# 模拟突变：随机替换一行注释为新的注释
function mutate() {
    at=$(date +%FT%T%:z)
    next=$((GEN + 1))
    child="data/${NAME}/${NAME}.g$next.sh"

    LINE_NUM=$(grep -n "^#### MUTATION:" "$ME" | shuf -n1 | cut -d: -f1)

    mkdir -p data/${NAME}
    segments=$(tr -dc "ATCG" < /dev/urandom | fold -w 42 | awk '{print $1; exit}')

    # 😈
    sed "${LINE_NUM} s|:.*|: $at, g$next, $segments|" "$ME" > "$child"
    chmod +x "$child"

    echo ${child}
}

# 模拟繁殖：复制自己并生成下一代
function reproduce_and_execute() {
    child=$(mutate)
    sleep $((RANDOM%3))

    if (( GEN + 1 <= MAX_GEN )); then
        echo "    🔁 $NAME generation $GEN creates ${child}"
        ./$child $MAX_GEN
    else
        echo "<== 🏁 Evolution of $NAME ends at generation $GEN"
    fi
}

reproduce_and_execute
