#!/bin/sh
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
	;;
esac

case `uname` in
FreeBSD)
	HOST=freebsd-clang
	;;
Linux)
	OS=linux-g++
	;;
Darwin)
	OS=macx-clang
	;;
esac

INCPATH=-I$ROOT/include
LIBDIR=-L$ROOT/lib
export INCPATH
export LIBDIR
./configure -prefix $ROOT -opensource -confirm-license -xplatform $OS-$COMPILER \
	-device-option CROSS_COMPILE=$CROSS_COMPILE -device-option QMAKE_LIBS=-lz \
	-release -platform $HOST -system-libpng -opengl desktop \
	-skip 3d -skip activeqt -skip canvas3d -skip connectivity -skip declarative \
	-skip doc -skip docgallery -skip enginio -skip feedback -skip graphicaleffects \
	-skip imageformats -skip location -skip pim -skip qa -skip quick1 \
	-skip quickcontrols -skip repotools -skip script -skip sensors \
	-skip serialport -skip svg -skip systems -skip tools -skip wayland \
	-skip webchannel -skip webengine -skip webkit -skip webkit-examples \
	-skip websockets -skip xmlpatterns \
	-nomake examples -nomake tools -nomake tests -no-compile-examples \
	-no-feature-printer -no-feature-printpreviewwidget -no-feature-printdialog \
	-no-feature-ftp -no-feature-udpsocket -no-feature-socks5 \
	-no-feature-networkproxy -no-feature-networkdiskcache -no-feature-dbus \
	-no-feature-bearermanagement -no-feature-mdiarea -no-feature-wizard \
	-no-feature-imageformat_ppm -no-feature-imageformat_xbm -no-feature-pdf \
	-no-feature-desktopservices \
	-no-feature-dial \
	-no-feature-dom \
	-no-feature-gestures \
	-no-feature-graphicseffect \
	-no-feature-lcdnumber \
	-no-feature-printpreviewdialog \
	-no-feature-textodfwriter \
	-no-feature-xmlstream \
	-no-feature-xmlstreamreader \
	-no-feature-xmlstreamwriter \
	-no-pch -no-freetype \
	-no-icu -no-gif -no-sql-odbc -no-harfbuzz -no-openssl -no-dbus \
	-I $ROOT/include -L $ROOT/lib -v -static -c++std c++11
