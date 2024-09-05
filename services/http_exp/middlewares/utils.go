package main

import (
	"errors"
	"strconv"
	"time"

	"github.com/d2jvkpn/gotk/ginx"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

func GetAccountIdRole(ctx *gin.Context) (accountId uuid.UUID, role string, err error) {
	var (
		e     error
		value string
	)

	if value, e = ginx.Get[string](ctx, "AccountId"); e != nil {
		return accountId, "", errors.New("no_value_in_context")
	}

	if accountId, e = uuid.Parse(value); e != nil {
		return accountId, "", errors.New("invalid_value_in_context")
	}

	if role, e = ginx.Get[string](ctx, "AccountRole"); e != nil {
		return accountId, "", errors.New("no_value_in_context")
	}

	return accountId, role, nil
}

func QueryBool(ctx *gin.Context, key string) (ans bool, err error) {
	var (
		ok    bool
		value string
		e     error
	)

	if value, ok = ctx.GetQuery(key); !ok {
		return false, errors.New("missing_parameter")
	}

	if ans, e = strconv.ParseBool(value); e != nil {
		return false, errors.New("invalid_parameter")
	}

	return ans, nil
}

func QueryString(ctx *gin.Context, key string) (str string, err error) {
	var ok bool

	if str, ok = ctx.GetQuery(key); !ok {
		return "", errors.New("missing_parameter")
	}

	return str, nil
}

func QueryStrings(ctx *gin.Context, key string) (strs []string, err error) {
	var ok bool

	if strs, ok = ctx.GetQueryArray(key); !ok {
		return nil, errors.New("missing_parameter")
	}

	return strs, nil
}

func QueryDate(ctx *gin.Context, key string) (date string, err error) {
	var (
		ok bool
		e  error
	)

	if date, ok = ctx.GetQuery(key); !ok {
		return "", errors.New("missing_parameter")
	}

	if _, e = time.ParseInLocation(time.DateOnly, date, time.Local); e != nil {
		return "", errors.New("invalid_parameter")
	}

	return date, nil
}

func BindJSON[T any](ctx *gin.Context, value *T) (err error) {
	var e error

	if e = ctx.BindJSON(value); e != nil {
		return errors.New("bind_json")
	}

	return nil
}

func BindQuery[T any](ctx *gin.Context, value *T) (err error) {
	var e error

	if e = ctx.BindQuery(value); e != nil {
		return errors.New("bind_query")
	}

	return nil
}
