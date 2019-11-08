package main

import "github.com/docker/docker/pkg/namesgenerator"

func main() {
	println(namesgenerator.GetRandomName(0))
}
