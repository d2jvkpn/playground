package main

import (
	//"encoding/json"
	"fmt"
	"log"
	"net/http"
	"time"
)

type Message struct {
	Event string
	Data  string
}

func main() {
	http.HandleFunc("/sse", sseHandler)
	log.Println("SSE server running on :8080")
	log.Fatal(http.ListenAndServe(":8080", nil))
}

func sseHandler(w http.ResponseWriter, r *http.Request) {
	// 设置SSE所需的响应头
	w.Header().Set("Content-Type", "text/event-stream")
	w.Header().Set("Cache-Control", "no-cache")
	w.Header().Set("Connection", "keep-alive")
	w.Header().Set("Access-Control-Allow-Origin", "*")

	// 创建通道用于模拟数据流
	messageChan := make(chan Message)
	defer close(messageChan)

	// 模拟LLM生成数据的过程
	go func() {
		for i := 0; i < 10; i++ {
			msg := Message{
				Event: "message",
				Data:  fmt.Sprintf("LLM生成的文本块 %d", i+1),
			}
			messageChan <- msg
			time.Sleep(1 * time.Second) // 模拟处理延迟
		}
		msg := Message{
			Event: "close",
			Data:  "流式传输完成",
		}
		messageChan <- msg
	}()

	// 监听客户端断开连接
	ctx := r.Context()
	flusher, _ := w.(http.Flusher)

	for {
		select {
		case <-ctx.Done():
			log.Println("客户端断开连接")
			return
		case msg := <-messageChan:
			if msg.Event == "close" {
				fmt.Fprintf(w, "event: %s\ndata: %s\n\n", msg.Event, msg.Data)
				flusher.Flush()
				return
			}

			// 发送SSE格式的数据
			fmt.Fprintf(w, "event: %s\ndata: %s\n\n", msg.Event, msg.Data)
			flusher.Flush()
		}
	}
}
