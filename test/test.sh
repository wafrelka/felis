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

# cd $test_dir/raytracer
# make
# cd $test_dir

cd $root/felis-simulator
mkdir -p build
cd build
cmake -DNO_ASSERT=Off -DCMAKE_BUILD_TYPE=Release ..
make -j5
cd $test_dir

mkdir -p ppm/sim diff

for f in $(ls sld/*.sld); do
    f2=${f#*/}
    f3=${f2%.*}
    # echo "raytracer" $f2
    # ./raytracer/minrt < $f > ppm/rt/$f3.ppm

    echo "simulator" $f2
    $root/felis-simulator/build/simulator -f $simbin -i $f -o ppm/sim/$f3.ppm -rq

    set +e
    diff ppm/rt/$f3.ppm ppm/sim/$f3.ppm > diff/$f3.diff
    set -e
done
