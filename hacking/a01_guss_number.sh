#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


min_range=${min_range:-1}
max_range=${max_range:-100}
max_times=${1:-7}
echo "==> 欢迎参加数字猜谜游戏(max_times=${max_times})！"

target=$((RANDOM % ($max_range - $min_range + 1) + $min_range))

n=0
win="no"
while (($n <= $max_times)); do
    n=$((n+1))
    ####
    read -p "--> 请输入一个猜测的数字 ($min_range - $max_range), ${n}/${max_times}: " guess

    if [[ ! "$guess" =~ ^[0-9]+$ ]]; then
        >&2 echo '!!! 错误：请输入一个有效的数字。'
        win="yes"
        continue
    elif ((guess < min_range || guess > max_range)); then
        >&2 echo '!!!' "错误：请输入 $min_range 到 $max_range 之间的数字。"
        continue
    fi

    ####
    if ((guess == target)); then
        echo "--> 恭喜你，猜对了！目标数字是 $target。"
        break
    elif ((n == max_times)); then
        echo '!!! '"你已经猜了 $max_times 次，游戏结束！"
        break
    elif ((guess < target)); then
        echo '!!! 太小了，再试一次。'
        min_range=$guess
    else
        echo '!!! 太大了，再试一次。'
        max_range=$guess
    fi
done
