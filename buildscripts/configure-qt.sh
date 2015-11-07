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
COMPILER=$(identify_compiler $CXX)

./configure -prefix $ROOT -opensource -confirm-license -xplatform $OS-$COMPILER \
	-device-option CROSS_COMPILE=$CROSS_COMPILE -no-icu -nomake examples \
	-skip 3d -skip activeqt -skip canvas3d -skip connectivity -skip declarative \
	-skip doc -skip docgallery -skip enginio -skip feedback -skip graphicaleffects \
	-skip location -skip pim -skip qa -skip quick1 -skip quickcontrols -skip repotools \
	-skip script -skip sensors -skip serialport -skip svg -skip systems -skip tools \
	-skip wayland -skip webchannel -skip webengine -skip webkit -skip webkit-examples \
	-skip websockets -skip xmlpatterns \
	-nomake tools -qt-harfbuzz -v
