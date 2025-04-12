#!/usr/bin/env bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

# chmod a+x ./_interactive.sh
# printf "Bot\nn\nJava\n" | ./_interactive.sh

echo "----------------"

echo "1. Hello, please introduce yourself."
echo -n "Your name: "
read -r name
echo -e "\n"

echo "2. Are you human?"
echo -n "y/n: "
read -r ans
echo -e "\n"

echo "3. What is your favorite programming language?"
echo -n "Your answer: "
read -r language
echo -e "\n"

echo "----------------"


printf 'Your answers: 1. "%s", 2. "%s", 3. "%s".\n' $name $ans $language
