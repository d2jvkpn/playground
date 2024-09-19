#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

min_range=1; max_range=100
max_times=${1:-7}

target=$((RANDOM % ($max_range - $min_range + 1) + $min_range))
echo "==> 欢迎参加数字猜谜游戏(max_times=${max_times})！"

n=1
while (($n <= $max_times)); do
    n=$((n+1))

    ####
    read -p "--> 请输入一个猜测的数字 ($min_range - $max_range): " guess

    if [[ ! "$guess" =~ ^[0-9]+$ ]]; then
        echo '!!! 错误：请输入一个有效的数字。'
        continue
    elif ((guess < min_range || guess > max_range)); then
        echo '!!!' "错误：请输入 $min_range 到 $max_range 之间的数字。"
        continue
    fi

    ####
    if ((guess == target)); then
        echo "--> 恭喜你，猜对了！目标数字是 $target。"
        break
    elif ((guess < target)); then
        echo '!!! 太小了，再试一次。'
        min_range=$guess
    else
        echo '!!! 太大了，再试一次。'
        max_range=$guess
    fi
done

[ $n -gt $max_times ] && {
  >&2 echo '!!! '"你已经猜了 $max_times 次，游戏结束！"
  exit 1
}
