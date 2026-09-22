# Title
---

#### ch01. 
1. docs
- https://www.odoo.com
- https://hub.docker.com/_/odoo/tags
- https://github.com/odoo/docker

2. error
```text
2026-07-31 07:42:07,160 1 WARNING odoo odoo.addons.base.models.ir_cron: Tried to poll an undefined table on database odoo.
2026-07-31 07:42:09,187 1 ERROR odoo odoo.sql_db: bad query: b"\n            SELECT latest_version\n            FROM ir_module_module\n             WHERE name='base'\n        "
ERROR: relation "ir_module_module" does not exist
LINE 3:             FROM ir_module_module
                         ^

2026-07-31 07:42:09,187 1 WARNING odoo odoo.addons.base.models.ir_cron: Tried to poll an undefined table on database odoo.
```

````bash
docker compose stop odoo
docker compose run --rm odoo odoo -d odoo -i base --without-demo=all --stop-after-init
docker compose up -d odoo
```

3. mount local dir to container's odoo-web (/var/lib/odoo)
```
mkdir -p data/odoo-web
sudo chown -R 100:101 data/odoo-web
```

4. backup odoo-web volume
```
voulme=odoo-web

tar -czf /mnt/extra-addons/odoo-web.tar.gz -C /var/lib/odoo .

# backup
docker run --rm \
  -v $voulme:/data/$voulme:ro \
  -v "$PWD/data":/backup \
  odoo:19 \
  tar -czf /backup/$voulme.tar.gz -C /data/$voulme .

# restore
docker run --rm \
  -v $voulme:/data/$voulme \
  -v "$PWD/data":/backup \
  odoo:19 \
  tar -xzf /backup/$voulme.tar.gz -C /data/$voulme
```
