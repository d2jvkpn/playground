package route

import (
	"log"
	"runtime"

	"demo-api/internal/ws"

	"github.com/gin-gonic/gin"
	"github.com/gorilla/websocket"
)

func talk(ctx *gin.Context) {
	var (
		token  string
		err    error
		conn   *websocket.Conn
		client *ws.Client
	)

	if conn, err = ws.Upgrader.Upgrade(ctx.Writer, ctx.Request, nil); err != nil {
		log.Printf("!!! %s talk upgrade error: %v\n", ctx.ClientIP(), err)
		return
	}
	// defer conn.Close() // Close in method of client

	client = ws.NewClient(ctx.ClientIP(), conn)
	token = ctx.DefaultQuery("token", "")

	// to avoid dead lock when for loop blocked by HandleMessage, don't use an unbuffered channel
	log.Printf(
		"==> %s connected: addr=%q, token=%q, Num Goroutine: %d\n",
		client.Id, client.Address, token, runtime.NumGoroutine(),
	)
	client.Handle()

	log.Printf("Num Goroutine: %d\n", runtime.NumGoroutine())
}
