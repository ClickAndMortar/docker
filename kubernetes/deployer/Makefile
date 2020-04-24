all: build push

default: build

build:
	docker build -t clickandmortar/k8s-deployer:buster-helm3 -t clickandmortar/k8s-deployer:latest .

push:
	docker push clickandmortar/k8s-deployer:buster-helm3
	docker push clickandmortar/k8s-deployer:latest
