#!/bin/bash

set -e

LLVM_PATH=/home/marcin/projects/llvm-project/build

export PATH=$LLVM_PATH/bin:$PATH
export LD_LIBRARY_PATH=$LLVM_PATH/lib:$LD_LIBRARY_PATH

# Uncomment one of those to print a particular type of DAG
#dag_type="-view-dag-combine1-dags"
#dag_type="-view-legalize-dags"
#dag_type="-view-dag-combine2-dags"
#dag_type="-view-isel-dags" # displays the DAG before the Select phase
#dag_type="-view-sched-dags" # displays the DAG before Scheduling

src=$1
if [[ ! -f "$src" ]]
then
    echo "File does not exist"
    exit 1
fi

mkdir -p build

echo "Compiling fox x86"

clang -Wno-everything -std=c11 -m32 -O3 -g -nostdinc -I. -Icsmith -Icsmith/X86 $src -o build/test_x86

opts="-std=c11 -target tinyRAM -I. -Icsmith -Icsmith/TinyRAM"
optsw="$opts -Wno-everything"

# DAG printing for 03 optimization level
#clang -S -emit-llvm $opts test.c -o test_tinyRAM_O3.ll
#llc -mtriple=tinyRAM -mcpu=v1 $dag_type < test_tinyRAM_O3.ll

echo "Compiling for TinyRAM"

echo "  Compiling runtime"
(cd ..; ./.compile.sh)

echo "  Compiling testcases with different opt levels"

clang $optsw -O3 -c $src -o build/test_O3.o
clang $optsw -O2 -c $src -o build/test_O2.o
clang $optsw -O1 -c $src -o build/test_O1.o

ld="-Tcsmith/TinyRAM/tinyRAM.ld"

ld.lld $ld -o build/test_O3 \
	build/test_O3.o ../build/runtime.o
ld.lld $ld -o build/test_O2 \
	build/test_O2.o ../build/runtime.o
ld.lld $ld -o build/test_O1 \
	build/test_O1.o ../build/runtime.o

llvm-objcopy -O binary build/test_O3 build/test_O3.bin
llvm-objcopy -O binary build/test_O2 build/test_O2.bin
llvm-objcopy -O binary build/test_O1 build/test_O1.bin

extract_hash="grep \"Answer: \""

echo "Executing x86 binary"

x86_hash=$(./build/test_x86 | eval $extract_hash)

echo "Executing TinyRAM binaries at different opt levels"

shopt -s expand_aliases
alias tinyram='/home/marcin/projects/emulator/installation/tinyram'

emulator_opts="-w 32 -r 16 --max-steps 20000000"
tinyRAM_O1_hash=$(tinyram $emulator_opts build/test_O3.bin empty empty | eval $extract_hash)
tinyRAM_O2_hash=$(tinyram $emulator_opts build/test_O2.bin empty empty | eval $extract_hash)
tinyRAM_O3_hash=$(tinyram $emulator_opts build/test_O1.bin empty empty | eval $extract_hash)

if [ "$x86_hash" == "$tinyRAM_O1_hash" ] && \
   [ "$tinyRAM_O1_hash" == "$tinyRAM_O2_hash" ] && \
   [ "$tinyRAM_O2_hash" ==  "$tinyRAM_O3_hash" ]
  then
    echo "TEST PASSED with: $x86_hash"
    exit 0
  else
    echo "!! TEST FAILED !!"
    echo "$x86_hash, $tinyRAM_O1_hash, $tinyRAM_O2_hash, $tinyRAM_O3_hash"
    exit 1
  fi

#llvm-objdump --triple=tinyRAM -Drt build/test_O3
#xxd -c 8 -g 1 test.bin

