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

func (client Client) String() string {
	bts, _ := json.Marshal(client)
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

	conn.SetPingHandler(func(appData string) (err error) {
		log.Printf("~~~ %s ping\n", client.Id)
		client.LastPing = time.Now()
		conn.WriteMessage(websocket.PongMessage, nil)
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

func (client *Client) Handle() {
	var err error

loop:
	for {
		// println("~~~ loop")
		select {
		case <-client.quit:
			break loop
		default:
			// this can block the loop
			if err = client.HandleMessage(); err != nil {
				log.Printf("!!! %s HandleMessage error: %v\n", client.Id, err)
				switch err.(type) {
				// close 1006 (abnormal closure): unexpected EOF
				case *websocket.CloseError:
					break loop
				}
			}
		}
	}

	client.Close()
}

func (client *Client) Close() {
	client.once.Do(func() {
		client.Online, client.ClosedAt = false, time.Now()
		client.conn.Close()

		go func() {
			<-time.After(3 * time.Second)
			log.Printf("delete client: %s\n", client)

			delete(_ClientsMap, client.Id)
		}()
	})
}

func (client *Client) HandleMessage() (err error) {
	var (
		ok        bool
		mt        int
		bts       []byte
		kind      string
		data, res map[string]any
	)

	// var addr: net.Addr = conn.RemoteAddr()
	if mt, bts, err = client.conn.ReadMessage(); err != nil {
		return
	}

	defer func() {
		bts, _ = json.Marshal(res)
		err = client.conn.WriteMessage(mt, bts)
	}()

	data = make(map[string]any)
	if json.Unmarshal(bts, &data); err != nil {
		res = map[string]any{"kind": "error", "message": "unmarshal message error"}
		return
	}
	log.Printf("<== %s recv: %s\n", client.Id, bytes.TrimSpace(bts))

	if kind, ok = data["kind"].(string); !ok {
		res = map[string]any{"kind": "error", "message": "invalid field kind"}
		return
	}

	if kind == "hello" {
		name, _ := data["name"].(string)

		res = map[string]any{
			"kind": "hello", "id": client.Id, "message": fmt.Sprintf("Welcome %s!", name),
		}
		return
	}

	res = map[string]any{"kind": "unknown", "message": "unkonw message kind"}
	return
}
