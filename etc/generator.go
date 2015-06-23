/*
Generator for making completion scripts automatically depending on the type of shell provided as argument.

Example usage:
$ script-generator fish
*/

package main

import (
	"fmt"
	"os"
)

func helpText() {
	fmt.Println("Incorrect usage.")
}

func parseArgs(args []string) {
	var shell string

	if len(args) == 0 {
		shell = os.Getenv("SHELL")
		fmt.Println(shell)
	} else if len(args) == 1 {
		shell = args[0]
		fmt.Println(shell)
	}
}

func main() {
	args := os.Args[1:]

	parseArgs(args)
}
