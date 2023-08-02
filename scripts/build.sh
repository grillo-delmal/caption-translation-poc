#!/usr/bin/bash

set -e

# Clean out folder
find /opt/out/ -mindepth 1 -maxdepth 1 -exec rm -r -- {} +

cd /opt
mkdir -p src

rsync -azh /opt/orig/LiveCaptions/ /opt/src/LiveCaptions/

pushd patches
for d in */ ; do
    for p in ${d}*.patch; do
        echo "patch /opt/patches/$p"
        git -C /opt/src/${d} apply /opt/patches/$p
    done
done
popd

export ONNX_ROOT=/opt/orig/onnxruntime/
export ONNXRuntime_ROOT_DIR=/opt/orig/onnxruntime/
export ONNXRuntime_INCLUDE_DIR=/opt/orig/onnxruntime/include/
export ONNXRuntime_ROOT_DIR=/opt/orig/onnxruntime/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/orig/onnxruntime/lib/

cd /opt/src/LiveCaptions/

meson setup builddir
cd builddir
ninja

rsync -azh /opt/src/LiveCaptions/builddir/ /opt/out/LiveCaptions/
cp /opt/orig/onnxruntime/lib/* /opt/out/LiveCaptions/src/