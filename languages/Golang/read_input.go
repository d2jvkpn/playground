package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

func main() {
	reader := bufio.NewReader(os.Stdin)
	fmt.Print("Enter text1: ")
	text1, _ := reader.ReadString('\n')
	fmt.Println(strings.TrimSpace(text1))

	fmt.Printf("Enter text2: ")
	text2 := ""
	fmt.Scanln(&text2)
	fmt.Println(text2)
}
