#!/bin/bash
if [ -z "$CMAKE_TOOLCHAIN_FILE" ]; then
	export CMAKE_TOOLCHAIN_FILE=$1
fi
if [ -z "$ROOT" ]; then
	export ROOT=$2
fi

BASEDIR=$(dirname $0)
. $BASEDIR/identify-toolchain.sh
OS=$(identify_os $CC)
CMAKE_EXTRA=""
case $OS in
OSX*)
	ARCH=${HOST%%-*}
	if [ -z "$ARCH" ]; then
		ARCH=$(arch)
	fi
	if [ $ARCH == aarch64 ]; then
		ARCH=arm64
	else
		CMAKE_EXTRA="-DCMAKE_OSX_DEPLOYMENT_TARGET=10.13"
	fi
	CMAKE_EXTRA="$CMAKE_EXTRA -DCMAKE_OSX_ARCHITECTURES=$ARCH -DCURL_USE_SECTRANSP=ON"
	;;
Windows*)
	CMAKE_EXTRA="-DCURL_STATIC_CRT=ON -DENABLE_UNICODE=ON"
	;;
esac

mkdir -p build
cd build && cmake .. \
	-DCMAKE_INSTALL_PREFIX="$ROOT" \
	-DCMAKE_TOOLCHAIN_FILE="$CMAKE_TOOLCHAIN_FILE" \
	-DBUILD_SHARED_LIBS=OFF \
	-DCURL_USE_LIBPSL=OFF \
	-DCURL_USE_LIBSSH2=OFF \
	$CMAKE_EXTRA
