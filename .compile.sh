#!/bin/bash

set -e

opts="-O3 -target tinyRAM -I. -target tinyRAM"

clang $opts -c lib/special.c -o build/special.o
clang $opts -c lib/start.c -o build/start.o
clang $opts -c lib/preamble.S -o build/preamble.o
clang $opts -c lib/memcpy.c -o build/memcpy.o
clang $opts -c lib/builtins.c -o build/builtins.o

ld.lld -relocatable \
	build/special.o \
	build/start.o \
	build/preamble.o \
	build/memcpy.o \
	build/builtins.o\
	-o build/runtime.o

