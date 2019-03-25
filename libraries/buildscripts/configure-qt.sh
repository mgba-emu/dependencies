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

unset CC
unset CXX
unset AR
unset RANLIB
unset STRIP
unset CPPFLAGS
unset CFLAGS
unset CXXFLAGS
unset LDFLAGS

case $OS in
FreeBSD*)
	OS=freebsd
	;;
Linux*)
	OS=linux
	;;
OSX*)
	OS=macx
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
	-xplatform $OS-$COMPILER \
	-device-option CROSS_COMPILE=$CROSS_COMPILE \
	-device-option QMAKE_LIBS=-lz \
	-release \
	-optimize-size \
	-I $ROOT/include \
	-L $ROOT/lib \
	-v \
	-static \
	-c++std c++14 \
	-system-libpng \
	-system-sqlite \
	-openssl-linked OPENSSL_LIBS="$OPENSSL_LIBS"\
	-opengl desktop \
	-no-pch \
	-no-avx2 \
	-nomake examples \
	-nomake tools \
	-nomake tests \
	-no-compile-examples \
	-no-freetype \
	-no-icu \
	-no-gif \
	-no-sql-odbc \
	-no-harfbuzz \
	-no-dbus \
