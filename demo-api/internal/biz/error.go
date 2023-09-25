package biz

import (
	"fmt"
)

func BizError() error {
	return fmt.Errorf("an expected biz error")
}
