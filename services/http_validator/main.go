package main

import (
	"flag"
	// "fmt"
	"net/http"
	"unicode"

	"github.com/gin-gonic/gin"
	"github.com/go-playground/validator/v10"
)

func main() {
	var (
		// release bool
		addr string

		engine *gin.Engine
	)

	flag.StringVar(&addr, "addr", ":1024", "http listening address")
	flag.Parse()

	// gin.SetMode(gin.ReleaseMode)
	// router = gin.New()
	engine = gin.Default()
	engine.ForwardedByClientIP = true
	engine.SetTrustedProxies([]string{"127.0.0.1", "192.168.1.2", "10.0.0.0/8"})

	engine.GET("/hello", hello)
	engine.GET("/get", get)
	engine.Run(addr)
}

func hello(ctx *gin.Context) {
	ctx.String(http.StatusOK, "Hello, world!\n")
	return
}

var (
	_DefaultValidator = validator.New()
)

// secondary func
func BindQuery[T any](ctx *gin.Context, query *T, validate bool) bool {
	var (
		err   error
		runes []rune
	)

	if err = ctx.BindQuery(query); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{
			"code": "bad_request",
			"kind": "InvalidParameter",
			"msg":  err.Error(),
		})
		return false
	}

	if !validate {
		return true
	}

	if err = _DefaultValidator.Struct(query); err != nil {
		errs := err.(validator.ValidationErrors)
		field := errs[0].Field()
		// fmt.Printf("==> error: %+v, filed: %q\n", err, field)

		runes = []rune(field)
		runes[0] = unicode.ToLower(runes[0])
		field = string(runes)

		ctx.JSON(http.StatusBadRequest, gin.H{
			"code": "bad_request",
			"kind": "InvalidParameter",
			"msg":  field,
		})
		return false
	}

	return true
}

// secondary func
func BindJSON[T any](ctx *gin.Context, query *T, validate bool) bool {
	var (
		err   error
		runes []rune
	)

	if err = ctx.BindJSON(query); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{
			"code": "bad_request",
			"kind": "InvalidParameter",
			"msg":  err.Error(),
		})
		return false
	}

	if !validate {
		return true
	}

	if err = _DefaultValidator.Struct(query); err != nil {
		errs := err.(validator.ValidationErrors)
		field := errs[0].Field()
		// fmt.Printf("==> error: %+v, filed: %q\n", err, field)

		runes = []rune(field)
		runes[0] = unicode.ToLower(runes[0])
		field = string(runes)

		ctx.JSON(http.StatusBadRequest, gin.H{
			"code": "bad_request",
			"kind": "InvalidParameter",
			"msg":  field,
		})
		return false
	}

	return true
}

// endpoint func
func get(ctx *gin.Context) {
	var query Query

	if !BindQuery(ctx, &query, true) {
		return
	}

	ctx.JSON(http.StatusOK, gin.H{"code": "ok", "kind": "", "data": gin.H{}})
}

// other layers: biz layer, middleware layer

// data layer: validation, manipulation, conversion
type Query struct {
	Status string `json:"status" form:"status" validate:"oneof='' yes no"`
}
