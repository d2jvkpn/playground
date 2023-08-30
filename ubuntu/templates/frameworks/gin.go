package main

import (
	// "fmt"
	"flag"
	"os"
	"strings"

	"github.com/gin-gonic/gin"
)

func main() {
	var (
		release bool
		addr    string
		engine  *gin.Engine
		router  *gin.RouterGroup
	)

	flag.StringVar(&addr, "addr", ":8080", "listening address")
	flag.BoolVar(&release, "release", false, "run in release mode")
	flag.Parse()

	if release {
		gin.SetMode(gin.ReleaseMode)
		engine = gin.New()
	} else {
		engine = gin.Default()
	}
	router = &engine.RouterGroup

	router.GET("/", func(ctx *gin.Context) {
		ctx.String(200, "Hello, world!\n")
		return
	})

	router.Run(port)
}
