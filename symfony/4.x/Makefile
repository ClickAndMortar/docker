all: build push

default: build

build:
	docker build -t clickandmortar/symfony:4.x -t clickandmortar/symfony:latest .

push:
	docker push clickandmortar/symfony:4.x
	docker push clickandmortar/symfony:latest
