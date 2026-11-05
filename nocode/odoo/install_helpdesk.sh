#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd -P)


## step 1 copy module dir
git clone \
  --depth 1 \
  --branch 19.0 \
  https://github.com/OCA/helpdesk.git \
  data/OCA--helpdesk.git

echo "location: /mnt/extra-addons/OCA/helpdesk"

## step 2 add module path to config
cat <<EOF
[options]
addons_path = /mnt/extra-addons,/mnt/extra-addons/OCA/helpdesk
EOF

## step 3 cli installation
container=odoo
db=odoo

docker exec "$container" \
  odoo \
  --database="$db" \
  --init=helpdesk_mgmt \
  --stop-after-init
