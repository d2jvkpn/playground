#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit

numfmt --to=si 1000000
# → 1.0M

numfmt --to=iec 1048576
# → 1.0M

echo 1M | numfmt --from=si
# → 1000000

echo 1M | numfmt --from=iec
# → 1048576

ls -l | numfmt --field=5 --to=iec

numfmt --to=iec --format='%.1f' 1048576
# → 1.0M

numfmt --to=si --suffix='B' 1000
# → 1.0KB

numfmt --to=iec --padding=8 1048576
# → "    1.0M"

numfmt --grouping 1000000 
# → 1,000,000
