all: build push

default: build

build:
	docker build -t clickandmortar/php:7.2-lua .

push:
	docker push clickandmortar/php:7.2-lua
