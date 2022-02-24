#!/usr/bin/env bash

set -e

(cd toolchain; docker build -t tinyram-llvm .)

mkdir -p build

docker run \
  -it \
  --name tinyram-llvm \
  --rm \
  -it \
  -v $(pwd):/code \
  -w /code \
  tinyram-llvm \
  /code/.compile.sh

