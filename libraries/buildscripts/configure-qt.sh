#!/bin/bash
if [ -z "$CROSS_COMPILE" ]; then
	export CROSS_COMPILE=$1
fi
if [ -z "$ROOT" ]; then
	export ROOT=$2
fi

BASEDIR=$(dirname $0)
QT=$(basename $PWD)
. $BASEDIR/identify-toolchain.sh
OS=$(identify_os $CC)
COMPILER=$(identify_compiler $CXX)

echo Configuring Qt in $PWD

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
FREETYPE="-system-freetype -no-harfbuzz"
OPENGL=desktop
case $OS in
FreeBSD*)
	OS=freebsd
	;;
Linux*)
	OS=linux
	FREETYPE="-system-freetype -system-harfbuzz"
	OVERRIDES=("QMAKE_LFLAGS=-pthread")
	LIBS="$LIBS -ldl"
	;;
OSX*)
	OS=macx
	SSL=-securetransport
	OPENSSL_LIBS=""
	ARCH=${HOST%%-*}
	if [ -z "$ARCH" ]; then
		ARCH=$(arch)
	fi
	if [ $ARCH == arm64 -o $ARCH == aarch64 ]; then
		OVERRIDES=(
			"QMAKE_MACOSX_DEPLOYMENT_TARGET=11.3"
			"QMAKE_APPLE_DEVICE_ARCHS=arm64"
		)
	else
		OVERRIDES=(
			"QMAKE_MACOSX_DEPLOYMENT_TARGET=10.13"
			"QMAKE_APPLE_DEVICE_ARCHS=x86_64"
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
	ARCH=$(arch)
	if [ $ARCH == arm64 -o $ARCH == aarch64 ]; then
		OPENGL=es2
	fi
	;;
Darwin)
	HOST=macx-clang
	;;
esac

QTFLAGS=()
case $QT in
qt5)
	QTFLAGS=(
		"-v"
		"-no-compile-examples"
		"-nomake tools"
	)
	;;
qt6)
	unset PKG_CONFIG_LIBDIR
	QTFLAGS=(
		"-no-feature-assistant"
		"-no-feature-designer"
		"-no-intelcet"
		"-no-feature-qml-animation"
		"-no-feature-qml-debug"
		"-no-feature-qml-delegate-model"
		"-no-feature-qml-itemmodel"
		"-no-feature-qml-jit"
		"-no-feature-qml-list-model"
		"-no-feature-qml-network"
		"-no-feature-qml-object-model"
		"-no-feature-qml-preview"
		"-no-feature-qml-profiler"
		"-no-feature-qml-sfpm-model"
		"-no-feature-qml-ssl"
		"-no-feature-qml-table-model"
		"-no-feature-qml-worker-script"
		"-no-feature-qml-xml-http-request"
		"-no-feature-qml-xmllistmodel"
	)
	;;
*)
	echo "Unknown Qt version"
	exit 1
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

pushd qttools
for PATCH in $(ls ../../patches/qttools/*.patch); do
	patch -Np1 < $PATCH
done
popd

set -x
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
	${QTFLAGS[*]} \
	-static \
	-c++std c++17 \
	-system-libpng \
	-system-sqlite \
	$SSL OPENSSL_LIBS="$OPENSSL_LIBS"\
	-opengl $OPENGL \
	-no-pch \
	-no-avx2 \
	-nomake examples \
	-nomake tests \
	-no-icu \
	-no-gif \
	-no-sql-odbc \
	$FREETYPE \
	${OVERRIDES[*]}
