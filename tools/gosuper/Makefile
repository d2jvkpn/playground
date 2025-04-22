build:
	mkdir -p target
	go build -o target/gosuper ./

test:
	target/gosuper --cmd "ping 127.0.0.1 -c 5" \
	  --postUp "echo '--> Output of postUp command'" --postDown "echo '--> Output of postDown command'"
