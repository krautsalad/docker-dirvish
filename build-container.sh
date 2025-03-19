#!/bin/sh
set -ex
docker build --no-cache --progress=plain -t krautsalad/dirvish:latest -f Dockerfile .
