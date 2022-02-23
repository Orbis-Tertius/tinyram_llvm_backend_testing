#!/bin/bash

set -e

git clone --depth 1 -b tinyRAM_backend-1 https://github.com/Orbis-Tertius/llvm-project
cd llvm-project
git checkout 1f7e48500466eaad9d3ee3bfec7b63f28f629f9a
mkdir build
cd build
CXX=clang++ CC=clang cmake \
  -DCMAKE_BUILD_TYPE=Release \
  -DLLVM_USE_LINKER=lld \
  -DLLVM_ENABLE_PROJECTS="clang;lld" \
  -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=TinyRAM \
  -G "Ninja" \
  ../llvm
ninja
mkdir /toolchain
cmake -DCMAKE_INSTALL_PREFIX=/toolchain -P cmake_install.cmake
cd ../..
rm -rf llvm-project

