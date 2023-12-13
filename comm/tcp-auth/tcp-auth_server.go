package main

import (
	"bufio"
	// "fmt"
	"flag"
	"log"
	"net"
	"strings"
)

var (
	_CorrectToken = "hello:world"
)

func handle(conn net.Conn) {
	defer conn.Close()

	var (
		data   string
		token  string
		err    error
		reader *bufio.Reader
	)

	reader = bufio.NewReader(conn)

	if data, err = reader.ReadString('\n'); err != nil {
		log.Println(err)
		return
	}

	token = strings.TrimSpace(data)
	log.Printf("~~~ Got token: %s\n", token)

	if token != _CorrectToken {
		conn.Write([]byte("Authorization failed!\n"))
		return
	}

	conn.Write([]byte("Authorized successfully!\n"))
}

func main() {
	var (
		addr     string
		err      error
		listener net.Listener
	)

	flag.StringVar(&addr, "addr", ":8000", "listening address")
	flag.Parse()

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
