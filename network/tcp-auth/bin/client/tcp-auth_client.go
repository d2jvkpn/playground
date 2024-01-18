package main

import (
	"bufio"
	"flag"
	"fmt"
	"io"
	"log"
	"net"
	"os"
	"strings"
	"time"
)

func main() {
	var (
		addr string
		err  *Error
	)

	flag.StringVar(&addr, "addr", "localhost:8000", "tcp server address")
	flag.Parse()

	for i := 0; i < 15; i++ {
		if err = connectToServer(addr); err == nil {
			return
		}

		if err.Kind() == "connect_error" {
			log.Println("!!!", err.Error())
			time.Sleep(time.Second)
			continue
		}

		log.Fatalln(err)
	}
}

type Error struct {
	cause error
	kind  string
}

func NewError(err error, kind string) *Error {
	return &Error{cause: err, kind: kind}
}

func (self *Error) IsNil() bool {
	return self.cause == nil
}

func (self *Error) Error() string {
	if self.IsNil() {
		return ""
	}

	return self.cause.Error()
}

func (self *Error) String() string {
	return fmt.Sprintf("kind: %s, cause: %v", self.kind, self.cause)
}

func (self *Error) Wrap() error {
	return fmt.Errorf("kind: %s, cause: %w", self.kind, self.cause)
}

func (self *Error) Kind() string {
	return self.kind
}

func connectToServer(addr string) *Error {
	var (
		token, msg string
		err        error
		reader     *bufio.Reader
		conn       net.Conn
	)

	if conn, err = net.Dial("tcp", addr); err != nil {
		return NewError(err, "connect_error")
	}
	log.Println("==> connected to", addr)

	fmt.Print("==> Enter token: ")
	reader = bufio.NewReader(os.Stdin)
	if token, err = reader.ReadString('\n'); err != nil {
		return NewError(err, "tcp_read")
	}
	token = strings.TrimSpace(token)
	if len(token) > 32 {
		return NewError(err, "token_is_too_long")
	}

	fmt.Fprintf(conn, token+"\n")

	if msg, err = bufio.NewReader(conn).ReadString('\n'); err != nil {
		log.Printf("read error: %s\n", err)
		conn.Close()
		return NewError(err, "bufio_read")
	}

	if msg = strings.TrimSpace(msg); msg != "ok" {
		log.Printf("==> Authorized failed: %q\n", strings.TrimSpace(msg))
		conn.Close()
		return NewError(err, "auth_failed")
	} else {
		log.Println("==> Authorized")
	}

	for {
		msg, err = bufio.NewReader(conn).ReadString('\n')
		if err != nil && err != io.EOF {
			log.Printf("read error: %s\n", err)
			conn.Close()
			return NewError(err, "bufio_read")
		}

		if err == io.EOF {
			break
		}

		log.Printf("==> Message from server: %q\n", strings.TrimSpace(msg))
	}

	_ = conn.Close()
	log.Printf("<== Connection closed\n")

	return nil
}
