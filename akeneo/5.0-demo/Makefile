all: build push

default: build

build:
	docker build -f Dockerfile -t clickandmortar/akeneo:5.0-demo .

push:
	docker push clickandmortar/akeneo:5.0-demo
