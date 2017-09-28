package main

import (
	"fmt"
	"os"
	"path"

	// Local Packages
	"github.com/rsdoiel/sheets-dataset-demo"
)

func main() {
	appName := path.Base(os.Args[0])
	fmt.Printf("%s %q\n", appName, demo.Run())
}
