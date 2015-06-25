/*
Generator for making completion scripts automatically depending on the type of shell provided as argument.

Example usage:
$ generator
	Should generate completion script for default shell

$ generator fish
	Should generate completion script for given shell. Fish in this situation.
*/

package main

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
)

func checkErr(err error) {
	if err != nil {
		panic(err)
	}
}

func parseArgs(args []string) string {
	var shell string
	var validshell bool

	if len(args) > 0 {
		shell = args[0]
	} else {
		shell = filepath.Base(os.Getenv("SHELL"))
	}

	shells := []string{"bash", "fish", "zsh"}
	for _, s := range shells {
		if s == shell {
			validshell = true
			break
		}
	}

	if !validshell {
		fmt.Println("Unsupported shell.")
		fmt.Printf("Supported shells are: %s\n", strings.Join(shells, " "))
		os.Exit(0)
	}

	return shell
}

func decideScript(shell string) {
	if shell == "bash" {
		generateBashScript()
	} else if shell == "fish" {
		generateFishScript()
	} else if shell == "zsh" {
		generateZshScript()
	} else {
		fmt.Println("Unknown shell")
	}
}

func generateBashScript() {
	fmt.Println("bash")
}

func generateFishScript() {
	fmt.Println("fish")
}

func generateZshScript() {
	fmt.Println("zsh")
}

func main() {
	args := os.Args[1:]

	shell := parseArgs(args)
	decideScript(shell)
}
