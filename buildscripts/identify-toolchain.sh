#!/bin/sh

if [ -z "$CROSS_COMPILE" ]; then
	CROSS_COMPILE=$1
	export CROSS_COMPILE
fi


if [ -x "$(which "$CROSS_COMPILE"cc)" ]; then
	export CC="$CROSS_COMPILE"cc
elif [ -x "$(which "$CROSS_COMPILE"gcc)" ]; then
	export CC="$CROSS_COMPILE"gcc
elif [ -x "$(which "$CROSS_COMPILE"clang)" ]; then
	export CC="$CROSS_COMPILE"clang
fi

if [ -x "$(which "$CROSS_COMPILE"c++)" ]; then
	export CXX="$CROSS_COMPILE"c++
elif [ -x "$(which "$CROSS_COMPILE"g++)" ]; then
	export CXX="$CROSS_COMPILE"gcc
elif [ -x "$(which "$CROS_COMPILE"clang++)" ]; then
	export CXX="$CROSS_COMPILE"clang
fi

if [ -x "$(which "$CROSS_COMPILE"gcc-ar)" ]; then
	export AR="$CROSS_COMPILE"gcc-ar
elif [ -x "$(which "$CROSS_COMPILE"ar)" ]; then
	export AR="$CROSS_COMPILE"ar
fi

if [ -x "$(which "$CROSS_COMPILE"gcc-ranlib)" ]; then
	export RANLIB="$CROSS_COMPILE"gcc-ranlib
elif [ -x "$(which "$CROSS_COMPILE"ranlib)" ]; then
	export RANLIB="$CROSS_COMPILE"ranlib
fi
export STRIP="$CROSS_COMPILE"strip

export CPPFLAGS=-I$ROOT/include
export LDFLAGS=-L$ROOT/lib

identify_os() {
	local CC=$1
	local PREPROC="$($CC -E -dM -x c - < /dev/null)"
	local OSX=$(echo "$PREPROC" | grep __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ | awk -F' ' '{ print $3 }')
	local LINUX=$(echo "$PREPROC" | grep __linux__)
	local WINDOWS=$(echo "$PREPROC" | grep _WIN32)
	local FREEBSD=$(echo "$PREPROC" | grep __FreeBSD__ | awk -F' ' '{ print $3 }')

	if [ -n "$OSX" ]; then
		echo "OSX$OSX"
		return 0
	fi
	if [ -n "$LINUX" ]; then
		echo "Linux"
		return 0
	fi
	if [ -n "$WINDOWS" ]; then
		echo "Windows"
		return 0
	fi
	if [ -n "$FREEBSD" ]; then
		echo "FreeBSD$FREEBSD"
		return 0
	fi
	return 1
}

identify_compiler() {
	local CXX=$1
	if $CXX --version 2>&1 | grep -q clang; then
		echo clang
		return 0
	fi
	if $CXX --version 2>&1 | grep -q GCC; then
		echo g++
		return 0
	fi
	return 1
}

if [ -n "$2" ]; then
	case $2 in
	AR)
		echo $AR
		;;
	CC)
		echo $CC
		;;
	CXX)
		echo $CXX
		;;
	RANLIB)
		echo $RANLIB
		;;
	STRIP)
		echo $STRIP
		;;
	esac
fi
