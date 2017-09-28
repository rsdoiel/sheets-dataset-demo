#
# Simple Makefile
#
PROJECT = demo

VERSION = $(shell grep -m1 'Version = ' $(PROJECT).go | cut -d\"  -f 2)

BRANCH = $(shell git branch | grep '* ' | cut -d\  -f 2)

build: bin/demo

bin/demo: demo.go cmd/demo/demo.go 
	go build -o bin/demo cmd/demo/demo.go

test:
	go test

website:
	./mk-website.bash

status:
	git status

save:
	if [ "$(msg)" != "" ]; then git commit -am "$(msg)"; else git commit -am "Quick Save"; fi
	git push origin $(BRANCH)

refresh:
	git fetch origin
	git pull origin $(BRANCH)

publish:
	./mk-website.bash
	./publish.bash

clean: 
	if [ -d bin ]; then /bin/rm -fR bin; fi
	if [ -d dist ]; then /bin/rm -fR dist; fi

install:
	env GOBIN=$(HOME)/bin go install cmd/demo/demo.go

dist/linux-amd64:
	mkdir -p dist/bin
	env  GOOS=linux GOARCH=amd64 go build -o dist/bin/demo cmd/demo/demo.go
	cd dist && zip -r $(PROJECT)-$(VERSION)-linux-amd64.zip README.md LICENSE INSTALL.md bin/* docs/* how-to/* demos/*
	rm -fR dist/bin


dist/macosx-amd64:
	mkdir -p dist/bin
	env  GOOS=darwin GOARCH=amd64 go build -o dist/bin/demo cmd/demo/demo.go
	cd dist && zip -r $(PROJECT)-$(VERSION)-macosx-amd64.zip README.md LICENSE INSTALL.md bin/* docs/* how-to/* demos/*
	rm -fR dist/bin


dist/windows-amd64:
	mkdir -p dist/bin
	env  GOOS=windows GOARCH=amd64 go build -o dist/bin/demo.exe cmds/demo/demo.go
	cd dist && zip -r $(PROJECT)-$(VERSION)-windows-amd64.zip README.md LICENSE INSTALL.md bin/* docs/* how-to/* demos/*
	rm -fR dist/bin


dist/raspbian-arm7:
	mkdir -p dist/bin
	env  GOOS=linux GOARCH=arm GOARM=7 go build -o dist/bin/demo cmds/demo/demo.go
	cd dist && zip -r $(PROJECT)-$(VERSION)-raspbian-arm7.zip README.md LICENSE INSTALL.md bin/* docs/* how-to/* demos/*
	rm -fR dist/bin

distribute_docs:
	mkdir -p dist/docs
	mkdir -p dist/how-to
	cp -v README.md dist/
	cp -v LICENSE dist/
	cp -v INSTALL.md dist/
	cp -v docs/*.md dist/docs/
	if [ -f dist/docs/nav.md ]; then rm dist/docs/nav.md; fi
	if [ -f dist/docs/index.md ]; then rm dist/docs/index.md; fi
	cp -v how-to/*.md dist/how-to/
	if [ -f dist/how-to/nav.md ]; then rm dist/how-to/nav.md; fi
	if [ -f dist/how-to/index.md ]; then rm dist/how-to/index.md; fi
	cp -vR demos dist/
	
release: distribute_docs dist/linux-amd64 dist/macosx-amd64 dist/windows-amd64 dist/raspbian-arm7

