#!/bin/bash
BASEDIR=$(dirname $0)
. $BASEDIR/identify-toolchain.sh
OS=$(identify_os $CC)
FLAGS=(CROSS="$1" BUILDMODE=static)
HOST_CC=(gcc)
CFLAGS=()
case $OS in
OSX*)
	BITS=64
	FLAGS+=(TARGET_SYS=Darwin LDFLAGS=-mmacosx-version-min=10.8)
	CFLAGS+=(-mmacosx-version-min=10.8)
	HOST_CC=(clang)
	;;
Windows64)
	BITS=64
	HOST_CC+=(-m64)
	;;
Windows*)
	BITS=32
	HOST_CC+=(-m32)
	;;
esac

case $OS in
Windows*)
	FLAGS+=(TARGET_SYS=Windows INSTALL_ANAME=liblua51.a)
	;;
esac

if [ $BITS -eq 64 ]; then
	CFLAGS+=(-fPIC -DLUAJIT_ENABLE_GC64)
fi

(cd $BASEDIR/../luajit && patch -Nsp1) < $BASEDIR/../patches/luajit/*

echo ${FLAGS[@]} CFLAGS=\"${CFLAGS[@]}\" HOST_CC=\"${HOST_CC[@]}\"
