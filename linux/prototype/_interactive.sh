#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})
# set -x

# chmod a+x ./_interactive.sh
# printf "Bot\nn\nJava\n" | ./_interactive.sh

echo "Hello, please introduce yourself."

echo -n "Your name: "
read -r name

echo "Are you human?"

echo -n "y/n: "
read -r human

echo "What is your favorite programming language?"

echo -n "Your answer: "
read -r lang

echo "Your answers: 1. $name, 2. $human, 3. $lang"
