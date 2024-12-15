build:
	bash containers/build.sh

deploy:
	bash containers/compose.sh

archive:
	mkdir -p target
	docker save kcptun:local -o target/kcptun_local.tar
	pigz -f target/kcptun_local.tar
