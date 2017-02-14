#!/bin/sh

set -e

if [ $# -eq 0 ]; then
    echo "Usgae: $0 [bin]"
    exit 1
fi
simbin=$1

cd $(git rev-parse --show-toplevel)
root=$PWD
test_dir=$root/test

# compile raytracer
cd $test_dir/raytracer
make
cd $test_dir

# compile simulator
cd $root/felis-simulator
if [ ! -e build ]; then
    mkdir build
fi
cd build
cmake -DNO_ASSERT=Off -DCMAKE_BUILD_TYPE=Release ..
make -j5
cd $test_dir

for f in $(ls sld/*.sld); do
    f2=${f#*/}
    f3=${f2%.*}

    echo "raytracer" $f3
    ./raytracer/minrt < $f > ppm/rt/$f3.ppm

    echo "simulator" $f3
    $root/felis-simulator/build/simulator -f $simbin -i $f -o ppm/sim/$f3.ppm -rq

    echo "diff" $f3
    set +e
    diff ppm/rt/$f3.ppm ppm/sim/$f3.ppm > diff/$f3.diff
    set -e
    python3 ppmdiff.py $f3 > diff/$f3.ppm
done
