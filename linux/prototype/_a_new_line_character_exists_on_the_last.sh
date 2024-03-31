#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

# echo "Hello, world!"

exit

####
mkdir -p data

echo -en 'hello\nHello\nHELLO' > data/a.txt
cat -A data/a.txt
[ $(tail -n 1 data/a.txt | wc -l) -eq 0 ] && >&2 echo "No new line found at the end."

####
sed -i -e $'$a\\' data/a.txt
[ $(tail -n 1 data/a.txt | wc -l) -gt 0 ]; && >&2 echo "New line found at the end."
