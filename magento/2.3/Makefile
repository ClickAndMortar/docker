all: build push

default: build

build:
	docker build -t clickandmortar/magento:2.3 -t clickandmortar/magento:latest .

push:
	docker push clickandmortar/magento:2.3
	docker push clickandmortar/magento:latest
