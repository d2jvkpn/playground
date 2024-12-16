build-image:
	docker build --no-cache --build-arg=BUILD_Region=cn -f containers/Containerfile -t kcptun:local ./

deploy-container:
	bash containers/compose.sh

archive-image:
	mkdir -p target
	docker save kcptun:local -o target/kcptun_local.tar
	pigz -f target/kcptun_local.tar
