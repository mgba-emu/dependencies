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
case $OS in
FreeBSD*)
	OS=generic-gnu
	;;
Linux*)
	OS=x86_64-linux-gcc
	;;
OSX*)
	OS=x86_64-darwin13-gcc
	;;
Windows64)
	OS=x86_64-win64-gcc
	;;
Windows*)
	OS=x86-win32-gcc
	;;
esac

patch -Np1 < $BASEDIR/../patches/libvpx/*

export LD=$CC
./configure --prefix=$ROOT --target=$OS --disable-examples --disable-docs \
	--disable-tools --disable-unit-tests --disable-decode-perf-tests \
	--disable-encode-perf-tests
