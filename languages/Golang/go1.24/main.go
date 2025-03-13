package main

import (
	"fmt"
	// "os"
	"database/sql"
	"runtime"
)

type Resource struct {
	db *sql.DB
}

func NewResource() *Resource {
	res := &Resource{db: nil} /*newDB()*/

	runtime.AddCleanup(res, func(db *sql.DB) {
		fmt.Println("<== Closing Resource.db connection")
		// _ = db.Close()
	}, res.db)

	return res
}

func main() {
	// fmt.Println("Hello, world!")

	//  Swiss Tables
	data := make(map[string]string, 4)
	data["hello"] = "world"
	fmt.Printf("==> data: %v\n", data)

	res := NewResource()
	// _ = res
	fmt.Printf("==> Resource created: %v\n", res)
	res = nil    // Drop reference to allow cleanup
	runtime.GC() // Force garbage collection for demonstration
}
