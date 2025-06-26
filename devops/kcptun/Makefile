build-image:
	docker build --no-cache -f containers/Containerfile \
	  --build-arg=BUILD_Region=cn -t kcptun:local ./

deploy-container:
	bash containers/compose.sh

archive-image:
	mkdir -p target
	docker save kcptun:local -o target/kcptun_local.tar
	pigz -f target/kcptun_local.tar
