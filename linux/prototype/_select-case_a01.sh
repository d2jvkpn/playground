#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

>&2 echo "==> Please select a menu option below: "

cat <<- EOF
  1. Print the winner of the Super Bowl
  2. Print the winner of the English Premier League
  3. Print the winner of La Liga
  4. Show me the current system date and time
  5. Show me every file that hasn't been modified in 45+ days
  *. Exit
EOF

read -t 5 _CHOICE

case "$_CHOICE" in
1) echo "The New England Patriots!"
   ;;
2) echo "Arsenal!"
   ;;
3) echo "Barcelona!"
   ;;
4) date +'%FT%T.%N%:z'
   ;;
5) find ./ -atime 45 -print 2>/dev/null
   ;;
*) >&2 echo "<== exit"
   ;;
esac
