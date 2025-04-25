#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


#### 1. print the line at the end of file and append a empty string
sed -n '$p; $a\ '

#### 2.
echo '
line1
---
line2
---
line3' | sed ':a; N; $!ba; s/\n---\n/,/g'
