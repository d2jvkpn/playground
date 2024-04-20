package main

import (
	// "fmt"
	"flag"

	"swagger/internal"

	"github.com/gin-gonic/gin"
)

func main() {
	var (
		release bool
		addr    string

		engine *gin.Engine
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

	internal.LoadSwagger(&engine.RouterGroup)
	engine.Run(addr)
}
