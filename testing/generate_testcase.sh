#!/bin/bash

set -e

# Use these options to generate very feature-limited C code
# Tier 1 testcases are generated with these options enabled
  #--no-arrays \
  #--no-structs \
  #--no-unions \
  #--no-muls \
  #--no-divs \
  #--no-bitfields \
  #--max-array-dim 1 \

csmith \
  --no-argc \
  --no-float \
  --no-packed-struct \
  --no-volatiles \
  --no-volatile-pointers \
  --no-builtins  \
  --max-expr-complexity 10 \
  --max-block-depth 5 \
  > test.c

