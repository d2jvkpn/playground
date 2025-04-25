#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


####
nodes=(node{01..05})

echo "==> first element ${nodes[0]}"
# node01

echo "==> range 1..3 ${nodes[@]:1:3}"
# node02, node03, node04

echo "==> range 1.. ${nodes[@]:1}"
# node02, node03, node04

####
foo=('foo bar' 'foo baz' 'bar baz')
bar=$(printf ",%s" "${foo[@]}")
echo ${bar:1}
# foo bar,foo baz,bar baz

####
foo=(a "b c" d)
echo $(IFS="," ; echo "${foo[*]}")

####
args=(1 2 3 4 5)
length=${#args[@]}
# 5

echo "${args[@]:0:length-1}"
# 1 2 3 4

echo ${args[length-1]}
# 5
