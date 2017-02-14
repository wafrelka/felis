#!/bin/sh

set -e

cd $(git rev-parse --show-toplevel)
root=$PWD

git submodule update --recursive --init

# compiler
echo "making compiler"
cd felis-compiler
make native-code
## globals.s
# cd globals_compiler
# g++ emit.cpp
# ./a.out < globals.in
cd $root

# assembler
echo "making assembler"
cd felis-assembler
make -s
cd $root

# simulator
echo "making simulator"
cd felis-simulator
if [ ! -e build ]; then
    mkdir build
fi
cd build
cmake ..
make gen_instruction
cmake -DCMAKE_BUILD_TYPE=Release ..
make
cd $root

# assemble
cd felis-assembler
./asm.sh ../felis-compiler/{sfiles/{array,globals,io,math_primitive,mathlib}.s,rt/raytracer/programs/minrt128.s}
cp code.bin $root/test/minrt128.bin
