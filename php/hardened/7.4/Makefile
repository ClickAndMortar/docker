all: build push

default: build

build:
	docker build -t clickandmortar/php:7.4-hardened -f Dockerfile.arm64 .

push:
	docker push clickandmortar/php:7.4-hardened
