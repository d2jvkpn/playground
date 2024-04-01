package internal

import (
	"fmt"
	"path/filepath"
	"testing"
)

func TestPath(t *testing.T) {
	fmt.Println(filepath.Join("", "a"))

	fmt.Println(filepath.Join("", "/a/"))

	fmt.Println(filepath.Join("b", "a"))

	fmt.Println(filepath.Join("b/", "/a/"))

	fmt.Println(filepath.Join("/b/", "/a/"))
}
