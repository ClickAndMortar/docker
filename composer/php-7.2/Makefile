all: build push

default: build

build:
	docker build -t clickandmortar/composer:php-7.2 .

push:
	docker push clickandmortar/composer:php-7.2
