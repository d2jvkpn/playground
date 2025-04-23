#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


extract_data() {
    sed -n '/^__DATA__$/,/^__END__/p' "$0" | tail -n +2 | head -n -1
}

# ....

echo "==> Extract embbed data"
extract_data

exit 0
__DATA__
embbed data line 1
embbed data line 2
__END__
