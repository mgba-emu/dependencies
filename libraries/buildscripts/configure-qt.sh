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
COMPILER=$(identify_compiler $CXX)

export QMAKE_CXXFLAGS=$CXXFLAGS
OPENSSL_LIBS="-lssl -lcrypto"
LIBS="-lz"

unset CC
unset CXX
unset AR
unset RANLIB
unset STRIP
unset CPPFLAGS
unset CFLAGS
unset CXXFLAGS
unset LDFLAGS

OVERRIDES=()
SSL=-openssl-linked
FREETYPE="-no-freetype -no-harfbuzz"
case $OS in
FreeBSD*)
	OS=freebsd
	;;
Linux*)
	OS=linux
	FREETYPE=""
	OVERRIDES=("QMAKE_LFLAGS=-pthread")
	LIBS="$LIBS -ldl"
	;;
OSX*)
	OS=macx
	SSL=-securetransport
	OPENSSL_LIBS=""
	if [ $(arch) == arm64 ]; then
		OVERRIDES=(
			"QMAKE_MACOSX_DEPLOYMENT_TARGET=11.0"
			"QMAKE_APPLE_DEVICE_ARCHS=arm64"
		)
	fi
	;;
Windows*)
	OS=win32
	OPENSSL_LIBS="$OPENSSL_LIBS -lws2_32 -lcrypt32"
	;;
esac

case `uname` in
FreeBSD)
	HOST=freebsd-clang
	;;
Linux)
	HOST=linux-g++
	;;
Darwin)
	HOST=macx-clang
	;;
esac

CROSS_FLAGS=()
if [ -n "$CROSS_COMPILE" ]; then
	CROSS_FLAGS=(
		"-xplatform" "$OS-$COMPILER"
		"-device-option" "CROSS_COMPILE=$CROSS_COMPILE"
	)
fi

INCPATH=-I$ROOT/include
LIBDIR=-L$ROOT/lib
export INCPATH
export LIBDIR

$BASEDIR/clean-extra.sh

pushd qtbase
for PATCH in $(ls ../../patches/qtbase/*.patch); do
	patch -Np1 < $PATCH
done
popd
pushd qttools
for PATCH in $(ls ../../patches/qttools/*.patch); do
	patch -Np1 < $PATCH
done
popd

./configure \
	-prefix $ROOT \
	-opensource \
	-confirm-license \
	-platform $HOST \
	${CROSS_FLAGS[*]} \
	-release \
	-optimize-size \
	QMAKE_LIBS="$LIBS" \
	-I $ROOT/include \
	-L $ROOT/lib \
	-v \
	-static \
	-c++std c++14 \
	-system-libpng \
	-system-sqlite \
	$SSL OPENSSL_LIBS="$OPENSSL_LIBS"\
	-opengl desktop \
	-no-pch \
	-no-avx2 \
	-nomake examples \
	-nomake tools \
	-nomake tests \
	-no-compile-examples \
	-no-icu \
	-no-gif \
	-no-sql-odbc \
	-no-dbus \
	$FREETYPE \
	${OVERRIDES[*]}
