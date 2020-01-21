all: build push

default: build

build:
	docker build --build-arg VERSION=3.1 -t clickandmortar/akeneo:3.1-demo .
	docker build --build-arg VERSION=3.2 -t clickandmortar/akeneo:3.2-demo .

push:
	docker push clickandmortar/akeneo:3.1-demo
	docker push clickandmortar/akeneo:3.2-demo
