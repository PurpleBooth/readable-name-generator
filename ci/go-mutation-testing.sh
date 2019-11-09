#!/usr/bin/env bash

set -euo pipefail

GOPATH=$(mktemp -d)
export GOPATH
export GO111MODULE=off

SOURCE_DIR="$GOPATH/src/github.com/purplebooth/release-name-generator"
PATH="$GOPATH/bin:$PATH"

mkdir -p "$SOURCE_DIR"
cp -r . "$SOURCE_DIR"

go get -t -v github.com/zimmski/go-mutesting/...

(
	cd "$SOURCE_DIR"
	go get -t -v .
	go-mutesting .
)

rm -rf "$GOPATH"
