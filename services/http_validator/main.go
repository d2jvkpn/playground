package main

import (
	"flag"
	// "fmt"
	"errors"
	"net/http"
	"strings"
	"unicode"

	"github.com/gin-gonic/gin"
	"github.com/go-playground/validator/v10"
)

var (
	_DefaultValidate = validator.New()
)

// github.com/d2jvkpn/gotk.ginx
// ginx.Validate
func Validate[T any](item *T) (err error) {
	var (
		errs   validator.ValidationErrors
		fields []string
	)

	toLower := func(field string) string {
		var runes []rune

		runes = []rune(field)
		runes[0] = unicode.ToLower(runes[0])
		return string(runes)
	}

	if err = _DefaultValidate.Struct(item); err != nil {
		errs = err.(validator.ValidationErrors)
		fields = make([]string, len(errs))
		// fmt.Printf("==> error: %+v, filed: %q\n", err, field)

		for i := range errs {
			fields[i] = toLower(errs[i].Field())
		}

		return errors.New(strings.Join(fields, ","))
	}

	return nil
}

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

// secondary func
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

	return true
}

// endpoint func
func get(ctx *gin.Context) {
	var (
		err   error
		query Query
	)

	query = NewQuery()
	if !BindQuery(ctx, &query) {
		return
	}

	if err = query.Validate(); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{
			"code": "bad_request",
			"kind": "InvalidParameter",
			"msg":  err.Error(),
		})
		return
	}

	ctx.JSON(http.StatusOK, gin.H{"code": "ok", "kind": "", "data": gin.H{}})
}

// other layers: biz layer, middleware layer

// data layer: validation, manipulation, conversion
type Query struct {
	// default: empty for all kinds of status
	Status    string `json:"status" form:"status" validate:"oneof=yes no" enum:"yes,no" extensions:"x-order=01"`
	PageSize  int64  `json:"pageSize" form:"pageSize" validate:"gte=10,lte=100" minimum:"10" maximum:"100" extensions:"x-order=02"`
	PageIndex int64  `json:"pageIndex" form:"pageIndex" validate:"gte=1" minimum:"1" extensions:"x-order=03"`

	ok bool
}

func NewQuery() Query {
	return Query{
		Status:    "yes",
		PageSize:  1,
		PageIndex: 10,
	}
}

func (self *Query) Validate() (err error) {
	if self.ok {
		return nil
	}
	// if self.PageSize == 0 { self.PageSize = 1 }
	// if self.PageIndex == 0 { self.PageIndex = 10 }

	if err = Validate(self); err != nil {
		return err
	}

	self.ok = true

	return nil
}
