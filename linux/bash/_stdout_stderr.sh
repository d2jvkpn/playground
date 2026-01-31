#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


echo "Redirect stdout to stderr: >&2" >&2
echo "Redirect stderr to stdout: 2>&1" 2>&1

#value=$(bash _test02.sh > /tmp/output.log)
value=$(echo "I'm stdout!"; >&2 echo "I'm stderr!")
echo $value

exit
command > output.log 2>&1
command &> output.log
