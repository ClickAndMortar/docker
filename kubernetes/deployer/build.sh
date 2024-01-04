#!/bin/bash

set -e

TAG=$1

if [ -z "$TAG" ]; then
  echo "Usage: $0 <tag>"
  exit 1
fi

docker build \
  --platform linux/amd64 \
  -t clickandmortar/k8s-deployer:${TAG} \
  .

docker push clickandmortar/k8s-deployer:${TAG}
