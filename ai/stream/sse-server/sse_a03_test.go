package main

import (
	//"fmt"
	"net/http"
	"testing"
	"time"
)

func TestServer(t *testing.T) {
	srv := &http.Server{
		Addr:         ":8080",
		ReadTimeout:  5 * time.Second,
		WriteTimeout: 0, // 对于SSE很重要，禁用写超时
	}

	/*
		go func() {
			for {
				time.Sleep(15 * time.Second)
				fmt.Fprintf(w, ": heartbeat\n\n")
				flusher.Flush()
			}
		}()
	*/

	srv.ListenAndServe()
}
