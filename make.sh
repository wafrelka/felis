#!/bin/sh

set -e

cd $(git rev-parse --show-toplevel)
root=$PWD

git submodule update --recursive --init

# compiler
echo "making compiler"
cd $root

# assembler
cd felis-assembler
echo "making assembler"
make -s
cd $root

# simulator
cd felis-simulator
echo "making simulator"
mkdir -p build
cd build
cmake ..
make gen_instruction
cmake ..
make
cd $root
