#!/bin/bash
if [ -z "$CMAKE_TOOLCHAIN_FILE" ]; then
	export CMAKE_TOOLCHAIN_FILE=$1
fi
if [ -z "$ROOT" ]; then
	export ROOT=$2
fi

mkdir -p build
cd build && cmake .. \
	-DCMAKE_INSTALL_PREFIX="$ROOT" \
	-DCMAKE_TOOLCHAIN_FILE="$CMAKE_TOOLCHAIN_FILE" \
	-DSDL_STATIC=ON \
	-DSDL_SHARED=OFF \
	-DLIBC=ON
