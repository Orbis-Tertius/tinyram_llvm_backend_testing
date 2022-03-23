#!/bin/bash

set -e

echo "TIER 1 testing"

for file in testcases_tier1/*.c
do
  ./compile_run.sh $file
done

echo "TIER 2 testing"

for file in testcases_tier2/*.c
do
  ./compile_run.sh $file
done
