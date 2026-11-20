TAG = clickandmortar/docker-android:emulator_14.0-chrome150

all: build push

default: build

build:
	docker build --platform linux/amd64 -f Dockerfile -t $(TAG) .

push:
	docker push $(TAG)
