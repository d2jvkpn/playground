package main

import (
	// "fmt"
	"flag"

	"swagger/docs"

	"github.com/gin-gonic/gin"
	"github.com/swaggo/files"
	"github.com/swaggo/gin-swagger"
)

func main() {
	var (
		release bool
		addr    string

		engine *gin.Engine
	)

	flag.StringVar(&addr, "addr", ":3056", "http listening address")
	flag.BoolVar(&release, "release", false, "run in release mode")
	flag.Parse()

	if release {
		gin.SetMode(gin.ReleaseMode)
		engine = gin.New()
	} else {
		engine = gin.Default()
	}
	engine.RedirectTrailingSlash = false

	LoadSwagger(&engine.RouterGroup)
	engine.Run(addr)
}

func LoadSwagger(router *gin.RouterGroup) {
	// programmatically set swagger info
	docs.SwaggerInfo.Title = "Swagger Example API"
	docs.SwaggerInfo.Description = "This is a sample server Petstore server."
	docs.SwaggerInfo.Version = "1.0"
	docs.SwaggerInfo.Host = "petstore.swagger.io"
	docs.SwaggerInfo.BasePath = "/v2"
	docs.SwaggerInfo.Schemes = []string{"http", "https"}

	/*
		router.GET("/swagger", func(ctx *gin.Context) {
			ctx.Redirect(http.StatusTemporaryRedirect, ctx.FullPath()+"/index.html")
		})

		router.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerFiles.Handler))
	*/

	router.GET("/*any", ginSwagger.WrapHandler(swaggerFiles.Handler))
}
