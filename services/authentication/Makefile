at = $(shell date +'%FT%T%:z')

#### cmd
build:
	echo ">>> ${at}"
	bash scripts/go_build.sh authentication
	ls -al target/

run:
	echo ">>> ${at}"
	bash scripts/go_build.sh authentication
	./target/authentication
