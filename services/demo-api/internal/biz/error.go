package biz

import (
	"fmt"
)

func BizError() error {
	return fmt.Errorf("an expected biz error")
}

func DivPanic() int {
	a, b := 1, 0

	return a / b
}
