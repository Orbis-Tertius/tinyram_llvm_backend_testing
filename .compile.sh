#!/bin/bash

clang -O3 -target tinyRAM -I. -c lib/special.c -o build/special.o
clang -O3 -target tinyRAM -I. -c lib/start.c -o build/start.o
clang -O3 -target tinyRAM -I. -c lib/preamble.S -o build/preamble.o
clang -O3 -target tinyRAM -I. -c lib/factorial.c -o build/factorial.o
clang -O3 -target tinyRAM -I. -c lib/main.c -o build/main.o

ld.lld -TtinyRAM.ld -o build/app \
  build/start.o \
  build/special.o \
  build/preamble.o \
  build/factorial.o \
  build/main.o

llvm-objcopy -O binary build/app build/app.bin

echo "Application objdump:"
llvm-objdump --triple=tinyRAM -Drt build/app
#xxd -c 8 -g 1 build/app.bin
