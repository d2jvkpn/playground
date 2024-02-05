package main

import (
	// "fmt"
	"log"
	"sync"
	"time"
)

func main() {
	var (
		ready bool
		mu    sync.Mutex
		cond  *sync.Cond
	)

	cond = sync.NewCond(&mu)

	go func() {
		// 模拟一项工作
		time.Sleep(time.Second * 2) // 假设工作耗时2秒
		mu.Lock()
		ready = true
		cond.Signal() // 发出信号，告知条件已满足
		mu.Unlock()
	}()

	mu.Lock()
	for !ready {
		log.Println("--> wait")
		cond.Wait() // 等待条件满足
	}
	log.Println("==> 条件满足，继续执行")
	// TODO: ...
	mu.Unlock()
}
