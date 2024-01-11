package main

import (
	"log"
	"net/http"
	"net/http/httputil"
	"net/url"
	"sync"
	"time"
)

type Server struct {
	URL          *url.URL
	Alive        bool
	mux          sync.RWMutex
	ReverseProxy *httputil.ReverseProxy
}

func (s *Server) SetAlive(alive bool) {
	s.mux.Lock()
	s.Alive = alive
	s.mux.Unlock()
}

func (s *Server) IsAlive() (alive bool) {
	s.mux.RLock()
	alive = s.Alive
	s.mux.RUnlock()
	return
}

type ServerPool struct {
	servers []*Server
	current int
}

func (s *ServerPool) AddBackend(server *Server) {
	s.servers = append(s.servers, server)
}

func (s *ServerPool) NextBackend() *Server {
	next := s.current % len(s.servers)
	s.current++

	// 如果当前服务器不健康，跳到下一个
	if !s.servers[next].IsAlive() {
		return s.NextBackend()
	}

	return s.servers[next]
}

func (s *ServerPool) HealthCheck() {
	for _, b := range s.servers {
		status := "up"
		alive := isServerAlive(b.URL)
		b.SetAlive(alive)
		if !alive {
			status = "down"
		}
		log.Printf("%s [%s]\n", b.URL, status)
	}
}

func isServerAlive(u *url.URL) bool {
	resp, err := http.Head(u.String())
	if err != nil {
		log.Println("Error:", err)
		return false
	}

	if resp.StatusCode >= 200 && resp.StatusCode <= 399 {
		return true
	}

	return false
}

func lb(w http.ResponseWriter, r *http.Request) {
	peer := serverPool.NextBackend()
	if peer != nil {
		peer.ReverseProxy.ServeHTTP(w, r)
	} else {
		http.Error(w, "No servers available", http.StatusServiceUnavailable)
	}
}

var serverPool ServerPool

func main() {
	server1 := NewServer("http://localhost:8081")
	server2 := NewServer("http://localhost:8082")

	serverPool.AddBackend(server1)
	serverPool.AddBackend(server2)

	// 创建一个健康检查的定时任务，每20秒检查一次
	go func() {
		for {
			serverPool.HealthCheck()
			time.Sleep(20 * time.Second)
		}
	}()

	http.HandleFunc("/", lb)
	http.ListenAndServe(":8080", nil)
}
