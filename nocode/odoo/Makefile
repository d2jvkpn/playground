.PHONY: create_dirs cp_config init_db

create_dirs:
	mkdir -p data/odoo-extra-addons data/odoo-config data/odoo-web

cp_config:
	mkdir -p data/examples
	docker run --rm -it odoo:19 cat /etc/odoo/odoo.conf > data/examples/odoo.default.conf

init_db:
	docker compose stop odoo
	docker compose run --rm odoo odoo -d odoo -i base --without-demo=all --stop-after-init
	docker compose up -d odoo
