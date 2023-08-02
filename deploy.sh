#!/usr/bin/bash

set -e

#find ./cache/ -mindepth 1 -maxdepth 1 -exec rm -r -- {} +
if [ ! -f "./cache/onnxruntime-linux-x64-1.15.1/lib/libonnxruntime.so" ]; then
    pushd cache
    wget https://github.com/microsoft/onnxruntime/releases/download/v1.15.1/onnxruntime-linux-x64-1.15.1.tgz
    tar xzvf onnxruntime-linux-x64-1.15.1.tgz
    popd
fi

podman build -t livecaptions-build .

mkdir -p $(pwd)/build_out

podman unshare chown $UID:$UID -R $(pwd)/build_out


podman run -ti --rm \
    -v $(pwd)/.git:/opt/.git/:ro,Z \
    -v $(pwd)/build_out:/opt/out/:Z \
    -v $(pwd)/patches:/opt/patches/:ro,Z \
    -v $(pwd)/src/LiveCaptions:/opt/orig/LiveCaptions/:ro,Z \
    -v $(pwd)/cache/onnxruntime-linux-x64-1.15.1:/opt/orig/onnxruntime/:ro,Z \
    localhost/livecaptions-build:latest

podman unshare chown 0:0 -R $(pwd)/build_out
