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
	_CorrectToken = "hello"
)

func handle(conn net.Conn) {
	defer conn.Close()

	var (
		addr   net.Addr
		data   string
		token  string
		err    error
		reader *bufio.Reader
	)

	addr = conn.RemoteAddr()
	log.Printf("==> client connected: %s\n", addr)

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
	conn.Close()
	log.Printf("<== close connection: %s\n", addr)
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
