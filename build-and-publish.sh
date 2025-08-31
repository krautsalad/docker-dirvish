#!/bin/sh
set -ex

docker build --no-cache --progress=plain -t krautsalad/dirvish:latest -f docker/Dockerfile .
docker push krautsalad/dirvish:latest

VERSION=$(git describe --tags "$(git rev-list --tags --max-count=1)")

docker tag krautsalad/dirvish:latest krautsalad/dirvish:${VERSION}
docker push krautsalad/dirvish:${VERSION}
