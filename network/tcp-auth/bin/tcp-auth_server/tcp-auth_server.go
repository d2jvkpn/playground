package main

import (
	// "bufio"
	"flag"
	"fmt"
	"log"
	"net"
	"time"
	// "strings"
)

var (
	_CorrectToken = "hello"
)

func handle(conn net.Conn) {
	defer conn.Close()

	var (
		addr        net.Addr
		token, temp []byte
		err         error
		// reader *bufio.Reader
	)

	addr = conn.RemoteAddr()
	log.Printf("==> client connected: %s\n", addr)

	/*
		reader = bufio.NewReader(conn)

		if token, err = reader.ReadString('\n'); err != nil {
			log.Println(err)
			return
		}

		token = strings.TrimSpace(token)
		log.Printf("~~~ Got token: %s\n", token)
	*/

	token, temp = make([]byte, 0, 32), make([]byte, 1)
	for i := 0; i < 33; i++ {
		if _, err = conn.Read(temp); err != nil {
			log.Println(err)
			return
		}

		if temp[0] == '\n' {
			break
		}
		token = append(token, temp[0])
	}

	log.Printf("~~~ Got token: %s\n", string(token))
	if string(token) != _CorrectToken {
		conn.Write([]byte("no\n"))
		return
	}

	conn.Write([]byte("ok\n"))

	fmt.Printf("==> Send Welcome\n")
	msg := fmt.Sprintf("Welcome, %s\n", time.Now().Format(time.RFC3339))
	_, _ = conn.Write([]byte(msg))
	_ = conn.Close()
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
