#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd -P)

git clone \
  --depth 1 \
  --branch 19.0 \
  https://github.com/OCA/product-variant.git \
  data/OCA--product-variant.git

echo <<EOF
location:
/mnt/extra-addons/product-variant/product_variant_name/
                                   ├── __manifest__.py
                                   ├── models/
                                   └── views/
EOF

exit
```conf path=odoo.conf
[options]
addons_path = /usr/lib/python3/dist-packages/odoo/addons,/mnt/extra-addons/product-variant
```

odoo \
  -c /etc/odoo/odoo.conf \
  -d YOUR_DB_NAME \
  -i product_variant_name \
  --stop-after-init --no-http

select name, state from ir_module_module where name = 'product_variant_name';

#### remove
odoo \
  -c /etc/odoo/odoo.conf \
  -d YOUR_DB_NAME \
  -u product_variant_name \
  --stop-after-init --no-http

docker exec -it <postgres_container> psql -U odoo YOUR_DB_NAME

select name, state from ir_module_module where name = 'product_variant_name';

update ir_module_module set state='uninstalled' where name='product_variant_name';

## 2026-11-17 uninstall
```sql
SELECT m.name, m.state
FROM ir_module_module_dependency d
JOIN ir_module_module m ON m.id = d.module_id
WHERE d.name = 'product_variant_name';

SELECT m.name, m.state
FROM ir_module_module_dependency d
JOIN ir_module_module m ON m.id = d.module_id
WHERE d.name = 'product_variant_name';
```

```bash
odoo shell -d odoo_dev -c /etc/odoo/odoo.conf
```

```odoo-shell
module = env['ir.module.module'].search([
    ('name', '=', 'product_variant_name')
])

module.button_immediate_uninstall()
```
