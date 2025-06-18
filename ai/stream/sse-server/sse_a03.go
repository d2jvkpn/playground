package main

import (
	"fmt"
	// "encoding/json"
	"log"
	"net/http"
	"sync"
	"time"
)

type Broker struct {
	clients map[chan string]bool
	sync.Mutex
}

func NewBroker() *Broker {
	return &Broker{
		clients: make(map[chan string]bool),
	}
}

func (b *Broker) AddClient(client chan string) {
	b.Lock()
	defer b.Unlock()
	b.clients[client] = true
}

func (b *Broker) RemoveClient(client chan string) {
	b.Lock()
	defer b.Unlock()
	delete(b.clients, client)
	close(client)
}

func (b *Broker) Broadcast(message string) {
	b.Lock()
	defer b.Unlock()
	for client := range b.clients {
		client <- message
	}
}

var broker = NewBroker()

func main() {
	// 启动模拟数据生成器
	go func() {
		for {
			time.Sleep(2 * time.Second)
			message := fmt.Sprintf("Data at %v", time.Now())
			broker.Broadcast(message)
		}
	}()

	http.HandleFunc("/events", sseHandler)
	log.Println("SSE broker server running on :8080")
	log.Fatal(http.ListenAndServe(":8080", nil))
}

func sseHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "text/event-stream")
	w.Header().Set("Cache-Control", "no-cache")
	w.Header().Set("Connection", "keep-alive")
	w.Header().Set("Access-Control-Allow-Origin", "*")

	flusher, ok := w.(http.Flusher)
	if !ok {
		http.Error(w, "Streaming unsupported", http.StatusInternalServerError)
		return
	}

	messageChan := make(chan string)
	broker.AddClient(messageChan)
	defer broker.RemoveClient(messageChan)

	ctx := r.Context()
	for {
		select {
		case <-ctx.Done():
			return
		case message := <-messageChan:
			fmt.Fprintf(w, "data: %s\n\n", message)
			flusher.Flush()
		}
	}
}

func sseHandler_v2(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "text/event-stream")
	w.Header().Set("Cache-Control", "no-cache")
	w.Header().Set("Connection", "keep-alive")
	w.Header().Set("Access-Control-Allow-Origin", "*")

	// 支持重连时的最后事件ID
	lastEventID := r.Header.Get("Last-Event-ID")
	if lastEventID != "" {
		log.Printf("Client reconnected with Last-Event-ID: %s", lastEventID)
	}

	flusher, _ := w.(http.Flusher)
	ctx := r.Context()

	eventID := 0
	if lastEventID != "" {
		// 简单处理: 从上次断开的地方继续
		// 实际应用中可能需要更复杂的逻辑
		fmt.Fprintf(w, "event: catchup\ndata: Catching up from %s\n\n", lastEventID)
		flusher.Flush()
	}

	for {
		select {
		case <-ctx.Done():
			return
		case <-time.After(1 * time.Second):
			eventID++
			// 发送不同类型的事件
			if eventID%3 == 0 {
				fmt.Fprintf(w, "event: status\nid: %d\ndata: {\"status\":\"processing\"}\n\n", eventID)
			} else {
				fmt.Fprintf(w, "event: data\nid: %d\ndata: {\"token\":\"token-%d\"}\n\n", eventID, eventID)
			}
			flusher.Flush()
		}
	}
}
