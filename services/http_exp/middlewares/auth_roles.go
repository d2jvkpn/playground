package main

import (
	"net/http"
	"slices"

	"github.com/d2jvkpn/gotk/ginx"
	"github.com/gin-gonic/gin"
)

func AuthRoles(fn gin.HandlerFunc, roles ...string) gin.HandlerFunc {
	return func(ctx *gin.Context) {
		var (
			role string
			err  error
		)

		if role, err = ginx.Get[string](ctx, "AccountRole"); err != nil {
			ctx.JSON(http.StatusInternalServerError, gin.H{
				"code": "unexpected",
				"kind": "NoValueInContext",
			})
			ctx.Abort()
			return
		}

		if len(roles) == 0 {
			fn(ctx)
			return
		}

		if !slices.Contains(roles, role) {
			ctx.JSON(http.StatusForbidden, gin.H{
				"code": "not_role",
				"kind": "NotRole",
			})
			ctx.Abort()
			return
		}

		fn(ctx)
		return
	}
}
