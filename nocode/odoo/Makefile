.PHONY: create_dirs cp_config init_db

create_dirs:
	mkdir -p data/odoo-addons data/odoo-config

cp_config:
	mkdir -p data/odoo-config
	docker run --rm -it odoo:19 cat /etc/odoo/odoo.conf > data/odoo-config/odoo.default.conf

init_db:
	docker compose stop odoo
	docker compose run --rm odoo odoo -d odoo -i base --without-demo=all --stop-after-init
	docker compose up -d odoo
