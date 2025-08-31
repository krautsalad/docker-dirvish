#!/bin/sh
set -ex

DIRVISH_VERSION=1.2.1

docker build \
    --build-arg DIRVISH_VERSION=${DIRVISH_VERSION} \
    --no-cache --progress=plain -t krautsalad/dirvish:latest -f docker/Dockerfile .
docker push krautsalad/dirvish:latest

VERSION=$(git describe --tags "$(git rev-list --tags --max-count=1)")

docker tag krautsalad/dirvish:latest krautsalad/dirvish:${VERSION}
docker push krautsalad/dirvish:${VERSION}
