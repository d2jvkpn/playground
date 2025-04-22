build:
	mkdir -p target
	go build -o target/gosuper 

test:
	target/gosuper --cmd "ping 127.0.0.1 -c 5" --postup "echo Started" --postdown "echo Stopped"
