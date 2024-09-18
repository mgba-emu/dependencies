#!/bin/bash
if [ -z "$CROSS_COMPILE" ]; then
	export CROSS_COMPILE=$1
fi
if [ -z "$ROOT" ]; then
	export ROOT=$2
fi

BASEDIR=$(dirname $0)
. $BASEDIR/identify-toolchain.sh
OS=$(identify_os $CC)

unset AR
unset CC
unset RANLIB
unset STRIP

case $OS in
Windows64)
	TARGET=mingw64
	;;
Windows*)
	TARGET=mingw
	;;
OSX*)
	if [ $ARCH == aarch64 ]; then
		TARGET=darwin64-arm64
	else
		TARGET=darwin64-x86_64
	fi
esac

CFLAGS=-I$ROOT/include
LDFLAGS=-L$ROOT/lib
export CFLAGS
export LDFLAGS

for PATCH in $(ls ../../patches/openssl/*.patch); do
	patch -Np1 < $PATCH
done

./config --prefix=$ROOT --openssldir=$ROOT --libdir=$ROOT/lib no-asm no-docs no-idea no-shared no-ssl3 $TARGET
