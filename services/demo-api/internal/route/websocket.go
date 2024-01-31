package route

import (
	"github.com/gin-gonic/gin"
)

func Load_Websocket(rg *gin.RouterGroup, handlers ...gin.HandlerFunc) {
	ws := rg.Group("/ws/open", handlers...)
	ws.GET("/talk", talk)
}
