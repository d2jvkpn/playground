package route

import (
	"context"
	// "fmt"
	"log"
	"net/http"
	"time"

	"demo-api/internal/biz"
	"demo-api/internal/settings"

	"github.com/d2jvkpn/gotk/ginx"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"go.opentelemetry.io/otel/attribute"
	"go.opentelemetry.io/otel/trace"
)

func Load_OpenV1(router *gin.RouterGroup, handlers ...gin.HandlerFunc) {
	group := router.Group("/api/v1/open", handlers...)

	group.GET("/ip", func(ctx *gin.Context) {
		ctx.JSON(http.StatusOK, gin.H{
			"code": 0, "msg": "ok", "data": gin.H{"ip": ctx.ClientIP()},
		})
	})
}

func Load_Biz(router *gin.RouterGroup, handlers ...gin.HandlerFunc) {
	group := router.Group("/api/v1/biz", handlers...)

	group.GET("/hello", Hello)

	group.GET("/error", func(ctx *gin.Context) {
		requestId := uuid.NewString()
		err := biz.BizError()

		ginx.SetRequestId(ctx, requestId)
		ginx.SetError(ctx, err)
		ginx.SetIdentity(ctx, map[string]string{"biz_id": "expected_0001", "ip": ctx.ClientIP()})
		ginx.SetData(ctx, map[string]any{"query": ctx.Request.URL.RawQuery})
		ginx.SetData(ctx, map[string]any{"ans": 42})

		ctx.JSON(http.StatusBadRequest, gin.H{
			"request_id": requestId, "code": -1, "msg": err.Error(), "data": gin.H{"ans": 42},
		})
	})

	group.GET("/div_panic", func(ctx *gin.Context) {
		requestId := uuid.NewString()

		ginx.SetRequestId(ctx, requestId)
		ginx.SetIdentity(ctx, map[string]string{"biz_id": "div_panci"})
		ginx.SetData(ctx, map[string]any{"ans": 42})

		ctx.JSON(http.StatusOK, gin.H{
			"request_id": requestId, "code": 0, "msg": "ok", "data": gin.H{"ans": biz.DivPanic()},
		})
	})
}

// Hello godoc
//
//	@Summary		Show an account
//	@Description	get string by ID
//	@Tags			accounts
//	@Accept			json
//	@Produce		json
//	@Param	id		path	int			true	"Account ID"
//	@Param	name	query	string		flase	"Account Name"
//	@Param	login	body	LoginUser	true	"user password"
//	@Success		200	{object}	Response
//	@Failure		400	{object}	error
//	@Failure		404	{object}	error
//	@Failure		500	{object}	error
//	@Router			/accounts/{id}	[get]
func Hello(ctx *gin.Context) {
	var (
		name   string
		value  int64
		reqCtx context.Context
	)

	reqCtx = ctx.Request.Context()
	value = settings.Config.Sub("hello").GetInt64("world")
	time.Sleep(27 * time.Millisecond)

	name = biz.Hello(reqCtx)

	commonLabels := []attribute.KeyValue{
		attribute.String("route.Hello", name),
	}

	span := trace.SpanFromContext(reqCtx)
	span.SetAttributes(commonLabels...)

	log.Printf(
		"==> route.Hello: trace_id=%s, span_id=%s\n",
		span.SpanContext().TraceID().String(), span.SpanContext().SpanID().String(),
	)

	time.Sleep(27 * time.Millisecond)

	// ctx.Header("StatusCode", strconv.Itoa(httpCode))
	// ctx.Header("Status", http.StatusText(http.StatusOK))
	// ctx.Header("Content-Type", "application/json; charset=utf-8")
	// ctx.Writer.Write(bts)

	ctx.JSON(http.StatusOK, gin.H{"value": value, "name": name})
	// span.End() // don't do this as it will be called by the middleware
}

type LoginUser struct {
	UserId   string `json:"userId"`
	Password string `json:"password"`
	Region   string `json:"region,omitempty"`
}

type Response struct {
	Code int32          `json:"code"`
	Msg  string         `json:"msg"`
	Data map[string]any `json:"data"`
}
