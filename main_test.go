package main

import (
	"io/ioutil"
	"os"
	"testing"
)

func TestOutputsANoneZeroLengthString(t *testing.T) {
	stdout := runMain()

	if len(stdout) <= 0 {
		t.Errorf("main() output \"%s\"; want content longer than 0", stdout)
	}
}

func runMain() string {
	r, w, _ := os.Pipe()
	tmp := os.Stdout
	defer func() {
		os.Stdout = tmp
	}()
	os.Stdout = w
	go func() {
		main()
		w.Close()
	}()
	stdout, _ := ioutil.ReadAll(r)
	return string(stdout)
}
