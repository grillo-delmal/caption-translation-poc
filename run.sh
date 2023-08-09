#!/usr/bin/env bash

pushd python-server
python3 main.py &
ID=$!
popd

if [ ! -f "./cache/april-english-dev-01110_en.april" ]; then
    pushd cache
    wget https://april.sapples.net/april-english-dev-01110_en.april
    popd
fi

export APRIL_MODEL_PATH=`pwd`/cache/april-english-dev-01110_en.april
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:`pwd`/cache/onnxruntime-linux-x64-1.15.1/lib
#export XDG_DATA_DIRS=$XDG_DATA_DIRS:`pwd`/build_out/LiveCaptions/

#mkdir -p ./build_out/LiveCaptions/glib-2.0/schemas
#find ./build_out/LiveCaptions/glib-2.0/schemas -mindepth 1 -maxdepth 1 -exec rm -r -- {} +
#cp ./build_out/LiveCaptions/data/* `pwd`/build_out/LiveCaptions/glib-2.0/schemas

cd ./build_out/LiveCaptions/
./src/livecaptions

kill -9 $ID