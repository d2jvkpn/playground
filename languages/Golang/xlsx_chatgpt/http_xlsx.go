package main

import (
	"fmt"
	"net/http"
	"os"

	"github.com/tealeg/xlsx"
)

func generateExcel() (*xlsx.File, error) {
	file := xlsx.NewFile()
	sheet, err := file.AddSheet("Sheet1")
	if err != nil {
		return nil, err
	}

	row := sheet.AddRow()
	cell := row.AddCell()
	cell.Value = "Hello, Excel!"

	// Add more data to your Excel file as needed...

	return file, nil
}

func downloadHandler(w http.ResponseWriter, r *http.Request) {
	file, err := generateExcel()
	if err != nil {
		http.Error(w, "Failed to generate Excel file", http.StatusInternalServerError)
		return
	}

	// Save the file to a temporary location
	tempFilePath := "./temp.xlsx"
	err = file.Save(tempFilePath)
	if err != nil {
		http.Error(w, "Failed to save Excel file", http.StatusInternalServerError)
		return
	}
	defer os.Remove(tempFilePath) // Clean up the temporary file afterwards

	// Set headers to indicate a file download
	w.Header().Set("Content-Disposition", "attachment; filename=temp.xlsx")
	w.Header().Set("Content-Type", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")

	// Serve the file
	http.ServeFile(w, r, tempFilePath)
}

func main() {
	http.HandleFunc("/download", downloadHandler)
	fmt.Println("Server started at http://localhost:8080")
	http.ListenAndServe(":8080", nil)
}

