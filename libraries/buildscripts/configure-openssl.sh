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
	SYSTEM=MINGW64
	MACHINE=x86_64
	export SYSTEM
	export MACHINE
	;;
Windows*)
	SYSTEM=MINGW32
	MACHINE=i686
	export SYSTEM
	export MACHINE
	;;
OSX*)
	MACHINE=${HOST%%-*}
	if [ -z "$MACHINE" ]; then
		MACHINE=$(arch)
	fi
	if [ $ARCH == aarch64 ]; then
		MACHINE=arm64
	fi
	export MACHINE
esac

CFLAGS=-I$ROOT/include
LDFLAGS=-L$ROOT/lib
export CFLAGS
export LDFLAGS

./config --prefix=$ROOT --openssldir=$ROOT no-shared no-ssl2 no-ssl3 no-idea
