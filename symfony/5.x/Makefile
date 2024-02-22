all: build push

default: build

build:
	#docker build --platform linux/amd64 -f Dockerfile -t clickandmortar/symfony:5.x-apache-php7.4 .
	docker build --platform linux/amd64 -f Dockerfile.php82 -t clickandmortar/symfony:5.x-apache-php8.2 .

push:
	#docker push clickandmortar/symfony:5.x-apache-php7.4
	docker push clickandmortar/symfony:5.x-apache-php8.2
