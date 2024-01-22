package tests

import (
	"bufio"
	"bytes"
	"flag"
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"
	"sync"
	"time"

	"github.com/gorilla/websocket"
)

func wsClient(args []string) {
	var (
		addr    string
		err     error
		flagSet *flag.FlagSet
		client  *WsClient
	)

	flagSet = flag.NewFlagSet("ws_client", flag.ContinueOnError)
	flagSet.StringVar(&addr, "addr", "ws://127.0.0.1:5031/ws/open/talk", "websocket address")
	flagSet.Parse(args)

	if client, err = NewWsClient(addr); err != nil {
		log.Fatal(err)
	}

	client.HandleMessage()
}

type WsClient struct {
	conn  *websocket.Conn
	mutex *sync.Mutex
	done  chan struct{}
	once  *sync.Once
}

func NewWsClient(addr string) (client *WsClient, err error) {
	var conn *websocket.Conn

	if !strings.HasPrefix(addr, "ws") {
		addr = "ws://" + addr
	}

	if conn, _, err = websocket.DefaultDialer.Dial(addr, nil); err != nil {
		return nil, err
	}

	client = &WsClient{
		conn:  conn,
		mutex: new(sync.Mutex),
		done:  make(chan struct{}, 1),
		once:  new(sync.Once),
	}

	// overwrite default handler(when receive a ping)
	conn.SetPingHandler(func(_data string) (err error) {
		client.mutex.Lock()
		defer client.mutex.Unlock()

		log.Printf("<~~ Recv ping\n")
		if err = conn.WriteMessage(websocket.PongMessage, nil); err != nil {
			log.Printf("!!! WriteMessage Pong: %v\n", err)
		}

		return nil
	})

	// overwrite default handler(when receive a pong after send a ping)
	conn.SetPongHandler(func(data string) (err error) {
		log.Printf("<~~ recv pong: %q\n", data)
		return nil
	})

	return client, nil
}

func (self *WsClient) Close() {
	self.once.Do(func() {
		close(self.done)
		self.conn.Close()
	})
}

func (self *WsClient) SetPing(dur time.Duration) {
	ticker := time.NewTicker(5 * time.Second)

	go func() {
		var pingId uint64

	loop:
		for {
			select {
			case <-self.done:
				break loop
			case _ = <-ticker.C:
				pingId += 1
				data := []byte(strconv.FormatUint(pingId, 10))
				self.mutex.Lock()
				defer self.mutex.Unlock()

				log.Printf("~~> send ping: %q\n", data)
				err := self.conn.WriteMessage(websocket.PingMessage, []byte(data))
				if err != nil {
					log.Printf("!!! WriteMessage ping: %v\n", err)
				}
			}
		}
	}()
}

func (self *WsClient) SendMsgFromConsole() {
	for {
		var (
			bts    []byte
			msg    string
			err    error
			reader *bufio.Reader
		)

		fmt.Printf("==> Enter message: ")
		reader = bufio.NewReader(os.Stdin)
		if msg, err = reader.ReadString('\n'); err != nil {
			log.Printf("!!! ReadString: %v\n", err)
			continue
		}

		msg = strings.TrimSpace(msg)

		if msg == "\\q" {
			log.Println("!!! exit client")
			self.Close()
			break
		}
		if bts = []byte(msg); len(bts) == 0 {
			continue
		}

		self.mutex.Lock()
		defer self.mutex.Unlock()

		if err = self.conn.WriteMessage(websocket.TextMessage, bts); err != nil {
			log.Printf("!!! WriteMessage text: %v\n", err)
		}
	}
}

func (self *WsClient) HandleMessage() {
	var (
		typ int
		bts []byte
		err error
	)

	for {
		if typ, bts, err = self.conn.ReadMessage(); err != nil {
			log.Printf("!!! ReadMessage error: %[1]T, %[1]v\n", err)
			break
		}

		log.Printf("<-- ReadMessage: type=%d, %s\n", typ, bytes.TrimSpace(bts))
		if typ == websocket.CloseMessage {
			break
		}
	}

	self.Close()
}

// https://pkg.go.dev/github.com/gorilla/websocket#pkg-types
//	TextMessage = 1
//	BinaryMessage = 2
//	CloseMessage = 8
//	PingMessage = 9
//	PongMessage = 10
