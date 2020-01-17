all: build push

default: build

build:
	docker build -t clickandmortar/vsf-proxy:latest .

push:
	docker push clickandmortar/vsf-proxy:latest
