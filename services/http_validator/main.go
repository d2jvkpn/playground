package main

import (
	"flag"
	"fmt"
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

func BindQuery[T any](ctx *gin.Context, query *T) bool {
	var err error

	if err = ctx.BindQuery(query); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{
			"code": "bad_request",
			"kind": "InvalidParameter",
			"msg":  err.Error(),
		})
		return false
	}

	if err = _DefaultValidator.Struct(query); err != nil {
		errs := err.(validator.ValidationErrors)
		field := errs[0].Field()
		fmt.Printf("==> error: %+v, filed: %q\n", err, field)

		if len(field) > 0 {
			r := []rune(field)
			r[0] = unicode.ToLower(r[0])
			field = string(r)
		}

		ctx.JSON(http.StatusBadRequest, gin.H{
			"code": "bad_request",
			"kind": "InvalidParameter",
			"msg":  field,
		})
		return false
	}

	return true
}

func get(ctx *gin.Context) {
	var query Query

	if !BindQuery(ctx, &query) {
		return
	}

	ctx.JSON(http.StatusOK, gin.H{"code": "ok", "kind": "", "data": gin.H{}})
}

type Query struct {
	Status string `json:"status" form:"status" validate:"oneof='' yes no"`
}
