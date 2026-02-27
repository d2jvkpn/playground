package main

import (
	"context"
	"log"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/grandcat/zeroconf"
)

func main() {
	// 你想广播的端口（一般是你的服务实际监听的端口）
	port := 4096

	// DNS-SD 约定：服务类型 = _xxx._tcp (或 _udp)
	serviceType := "_demo._tcp"
	domain := "local."

	// “实例名”：局域网里展示给人看的名字
	instance := "MyDemoService"

	// TXT 记录：附带一些元信息（可选）
	txt := []string{
		"path=/",
		"version=1",
		"note=hello-mdns",
	}

	// Register 会在本机所有网卡上广播（默认）
	server, err := zeroconf.Register(instance, serviceType, domain, port, txt, nil)
	if err != nil {
		log.Fatalf("register mdns failed: %v", err)
	}
	defer server.Shutdown()

	log.Printf("[+] mDNS service registered: %s.%s.%s port=%d",
		instance, serviceType, domain, port)

	// 等待退出信号
	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer stop()

	<-ctx.Done()
	log.Println("[!] shutting down...")
	time.Sleep(200 * time.Millisecond)
}
