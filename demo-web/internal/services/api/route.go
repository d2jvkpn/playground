package api

import (
	// "fmt"

	"github.com/gin-gonic/gin"
)

func LoadV1_Open(router *gin.RouterGroup, handlers ...gin.HandlerFunc) {
	open := router.Group("/api/v1/open", handlers...)

	open.GET("/hello", hello)
	open.GET("/world", world)
}
