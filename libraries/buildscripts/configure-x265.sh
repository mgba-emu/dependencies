#!/bin/bash
if [ -z "$CMAKE_TOOLCHAIN_FILE" ]; then
	export CMAKE_TOOLCHAIN_FILE=$1
fi
if [ -z "$ROOT" ]; then
	export ROOT=$2
fi

BASEDIR=$(dirname $0)
patch -Np1 < $BASEDIR/../patches/x265/*

cmake source \
	-DCMAKE_INSTALL_PREFIX="$ROOT" \
	-DCMAKE_TOOLCHAIN_FILE="$CMAKE_TOOLCHAIN_FILE" \
	-DENABLE_CLI=OFF \
	-DENABLE_SHARED=OFF \
	-DSTATIC_LINK_CRT=ON \
	-DCMAKE_ASM_NASM_FLAGS=-w-macro-params-legacy \
	-DASM_FLAGS="$ASFLAGS" \
	$CMAKE_FLAGS
