all: build push

default: build

build:
	docker build --build-arg VERSION=4.0 -t clickandmortar/akeneo:4.0-demo .

push:
	docker push clickandmortar/akeneo:4.0-demo
