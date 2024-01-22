package ws

import (
	"bytes"
	"encoding/json"
	"fmt"
	"log"
	"sync"
	"sync/atomic"
	"time"

	"github.com/gorilla/websocket"
)

const (
	TimeFormat = "2006-01-02T15:04:05.000-07:00"
)

var (
	_ClientId uint64 = 0

	_ClientsMap = make(map[string]*Client, 100)
	Upgrader    = websocket.Upgrader{EnableCompression: true}
)

type Client struct {
	Id        string    `json:"id"`
	Address   string    `json:"address"`
	Online    bool      `json:"online"`
	CreatedAt time.Time `json:"createdAt"`
	ClosedAt  time.Time `json:"closedAt"`
	LastPing  time.Time `json:"lastPing"`

	conn *websocket.Conn
	quit chan struct{}
	once *sync.Once
}

func (self Client) String() string {
	bts, _ := json.Marshal(self)
	return string(bts)
}

func CloseAllClients() {
	for _, c := range _ClientsMap {
		if c.Online {
			c.Close()
		}
	}
}

func NewClient(address string, conn *websocket.Conn) *Client {
	client := &Client{
		Id:        fmt.Sprintf("c%06d", atomic.AddUint64(&_ClientId, 1)),
		Address:   address,
		Online:    true,
		CreatedAt: time.Now(),

		conn: conn,
		quit: make(chan struct{}, 1),
		once: new(sync.Once),
	}

	_ClientsMap[client.Id] = client

	conn.SetPingHandler(func(data string) (err error) {
		log.Printf("~~~ %s ping: %q\n", client.Id, data)
		client.LastPing = time.Now()
		conn.WriteMessage(websocket.PongMessage, []byte(data))
		return nil
	})

	conn.SetCloseHandler(func(code int, text string) error {
		log.Printf("<== %s closed: code=%d, text=%q\n", client.Id, code, text)
		// println("~~~ before send to quit")
		client.quit <- struct{}{}
		// println("~~~ after send to quit")
		return nil
	})

	return client
}

func (self *Client) Handle() {
	var err error

	_ = self.conn.WriteMessage(websocket.TextMessage, []byte(`{"kind":"hello"}`))

loop:
	for {
		select {
		case <-self.quit:
			break loop
		default:
			// this can block the loop
			if err = self.HandleMessage(); err != nil {
				log.Printf("!!! %s HandleMessage error: %v\n", self.Id, err)
				switch err.(type) {
				// close 1006 (abnormal closure): unexpected EOF
				case *websocket.CloseError:
					break loop
				}
			}
		}
	}

	self.Close()
}

func (self *Client) Close() {
	self.once.Do(func() {
		self.Online, self.ClosedAt = false, time.Now()
		self.conn.Close()

		go func() {
			<-time.After(3 * time.Second)
			log.Printf("delete client: %s\n", self)

			delete(_ClientsMap, self.Id)
		}()
	})
}

func (self *Client) HandleMessage() (err error) {
	var (
		ok        bool
		mt        int
		bts       []byte
		kind      string
		data, res map[string]any
	)

	// var addr: net.Addr = conn.RemoteAddr()
	if mt, bts, err = self.conn.ReadMessage(); err != nil {
		return
	}

	defer func() {
		bts, _ = json.Marshal(res)
		err = self.conn.WriteMessage(mt, bts)
	}()

	data = make(map[string]any)
	if json.Unmarshal(bts, &data); err != nil {
		res = map[string]any{"kind": "error", "message": "unmarshal message error"}
		return
	}
	log.Printf("<== %s recv: %s\n", self.Id, bytes.TrimSpace(bts))

	if kind, ok = data["kind"].(string); !ok {
		res = map[string]any{"kind": "error", "message": "invalid field kind"}
		return
	}

	if kind == "hello" {
		name, _ := data["name"].(string)

		res = map[string]any{
			"kind": "hello", "id": self.Id, "message": fmt.Sprintf("Welcome %s!", name),
		}
		return
	}

	res = map[string]any{"kind": "unknown", "message": "unkonw message kind"}
	return
}
