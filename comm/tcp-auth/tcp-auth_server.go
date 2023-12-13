package main

import (
	"bufio"
	// "fmt"
	"log"
	"net"
	"os"
	"strings"
)

var correctToken = "hello:world"

func handle(conn net.Conn) {
	defer conn.Close()

	reader := bufio.NewReader(conn)
	data, err := reader.ReadString('\n')
	if err != nil {
		log.Println(err)
		return
	}

	token := strings.TrimSpace(data)
	log.Printf("~~~ Got token: %s\n", token)
	if token != correctToken {
		conn.Write([]byte("Authorization failed!\n"))
		return
	}

	conn.Write([]byte("Authorized successfully!\n"))
	conn.Close()
}

func main() {
	var (
		addr     string
		err      error
		listener net.Listener
	)

	addr = os.Args[1]
	if listener, err = net.Listen("tcp", addr); err != nil {
		log.Fatalln(err)
	}
	log.Printf("==> tcp server: %q\n", addr)

	for {
		conn, err := listener.Accept()
		if err != nil {
			log.Println(err)
			continue
		}

		go handle(conn)
	}
}
