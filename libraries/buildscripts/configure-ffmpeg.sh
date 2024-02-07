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
ARCH=x86
case $OS in
FreeBSD*)
	OS=freebsd
	;;
Linux*)
	OS=linux
	case $(uname -m) in
	aarch64)
		ARCH=arm64
		;;
	x86_64)
		ARCH=x86_64
		;;
	i*86)
		ARCH=x86
		;;
	esac
	ELDFLAGS="-pthread"
	;;
OSX*)
	OS=darwin
	ARCH=${HOST%%-*}
	if [ -z "$ARCH" ]; then
		ARCH=$(arch)
	fi
	if [ $ARCH == arm64 -o $ARCH == aarch64 ]; then
		ARCH=arm64
	else
		ARCH=x86_64
	fi
	ELDFLAGS="-arch $ARCH"
	;;
Windows64)
	OS=win64
	ARCH=x86_64
	NVENC="--enable-encoder=h264_nvenc --enable-encoder=hevc_nvenc --enable-nvenc"
	;;
Windows*)
	OS=win32
	NVENC="--enable-encoder=h264_nvenc --enable-encoder=hevc_nvenc --enable-nvenc"
	;;
esac

set -x
./configure --disable-decoders --disable-devices --disable-outdevs --disable-demuxers --disable-hwaccels \
	--disable-encoders \
	--enable-encoder=libopus \
	--enable-encoder=aac \
	--enable-encoder=ac3 \
	--enable-encoder=ac3_fixed \
	--enable-encoder=apng \
	--enable-encoder=ffv1 \
	--enable-encoder=ffvhuff \
	--enable-encoder=flac \
	--enable-encoder=flv \
	--enable-encoder=gif \
	--enable-encoder=huffyuv \
	--enable-encoder=libmp3lame \
	--enable-encoder=libopus \
	--enable-encoder=libvpx_vp8 \
	--enable-encoder=libvpx_vp9 \
	--enable-encoder=libwebp \
	--enable-encoder=libwebp_anim \
	--enable-encoder=libx264 \
	--enable-encoder=libx264rgb \
	--enable-encoder=libx265 \
	--enable-encoder=mjpeg \
	--enable-encoder=mpeg4 \
	--enable-encoder=pcm_alaw \
	--enable-encoder=pcm_f32be \
	--enable-encoder=pcm_f32le \
	--enable-encoder=pcm_mulaw \
	--enable-encoder=pcm_s16be \
	--enable-encoder=pcm_s16be_planar \
	--enable-encoder=pcm_s16le \
	--enable-encoder=pcm_s16le_planar \
	--enable-encoder=pcm_s24be \
	--enable-encoder=pcm_s24daud \
	--enable-encoder=pcm_s24le \
	--enable-encoder=pcm_s24le_planar \
	--enable-encoder=pcm_s32be \
	--enable-encoder=pcm_s32le \
	--enable-encoder=pcm_s32le_planar \
	--enable-encoder=pcm_u16be \
	--enable-encoder=pcm_u16le \
	--enable-encoder=pcm_u24be \
	--enable-encoder=pcm_u24le \
	--enable-encoder=pcm_u32be \
	--enable-encoder=pcm_u32le \
	--enable-encoder=png \
	--enable-encoder=vorbis \
	--enable-encoder=wavpack \
	--enable-encoder=yuv4 \
	--enable-encoder=zlib \
	--enable-encoder=zmbv \
	\
	--disable-parsers \
	--enable-parser=aac \
	--enable-parser=aac_latm \
	--enable-parser=ac3 \
	--enable-parser=dirac \
	--enable-parser=flac \
	--enable-parser=h264 \
	--enable-parser=mjpeg \
	--enable-parser=mpeg4video \
	--enable-parser=mpegaudio \
	--enable-parser=opus \
	--enable-parser=png \
	--enable-parser=vorbis \
	--enable-parser=vp8 \
	--enable-parser=vp9 \
	\
	--disable-muxers \
	--enable-muxer=ac3 \
	--enable-muxer=apng \
	--enable-muxer=avi \
	--enable-muxer=dirac \
	--enable-muxer=flac \
	--enable-muxer=flv \
	--enable-muxer=gif \
	--enable-muxer=h264 \
	--enable-muxer=hls \
	--enable-muxer=image2 \
	--enable-muxer=image2pipe \
	--enable-muxer=ipod \
	--enable-muxer=latm \
	--enable-muxer=m4v \
	--enable-muxer=matroska \
	--enable-muxer=matroska_audio \
	--enable-muxer=mjpeg \
	--enable-muxer=mkvtimestamp_v2 \
	--enable-muxer=mov \
	--enable-muxer=mp3 \
	--enable-muxer=mp4 \
	--enable-muxer=mpegts \
	--enable-muxer=null \
	--enable-muxer=nut \
	--enable-muxer=oga \
	--enable-muxer=ogg \
	--enable-muxer=opus \
	--enable-muxer=pcm_alaw \
	--enable-muxer=pcm_f32be \
	--enable-muxer=pcm_f32le \
	--enable-muxer=pcm_mulaw \
	--enable-muxer=pcm_s16be \
	--enable-muxer=pcm_s16le \
	--enable-muxer=pcm_s24be \
	--enable-muxer=pcm_s24le \
	--enable-muxer=pcm_s32be \
	--enable-muxer=pcm_s32le \
	--enable-muxer=pcm_s8 \
	--enable-muxer=pcm_u16be \
	--enable-muxer=pcm_u16le \
	--enable-muxer=pcm_u24be \
	--enable-muxer=pcm_u24le \
	--enable-muxer=pcm_u32be \
	--enable-muxer=pcm_u32le \
	--enable-muxer=pcm_u8 \
	--enable-muxer=psp \
	--enable-muxer=rtp \
	--enable-muxer=rtp_mpegts \
	--enable-muxer=rtsp \
	--enable-muxer=smjpeg \
	--enable-muxer=wav \
	--enable-muxer=webm \
	--enable-muxer=webm_dash_manifest \
	--enable-muxer=webp \
	--enable-muxer=yuv4mpegpipe \
	\
	--disable-protocols \
	--enable-protocol=cache \
	--enable-protocol=concat \
	--enable-protocol=data \
	--enable-protocol=file \
	--enable-protocol=hls \
	--enable-protocol=http \
	--enable-protocol=httpproxy \
	--enable-protocol=pipe \
	--enable-protocol=rtmp \
	--enable-protocol=rtmpt \
	--enable-protocol=rtp \
	--enable-protocol=tcp \
	--enable-protocol=udp \
	--enable-protocol=udplite \
	\
	--disable-filters \
	--enable-filter=palettegen \
	--enable-filter=paletteuse \
	--enable-filter=scale \
	--enable-filter=split \
	\
	--disable-bsfs \
	--enable-bsf=aac_adtstoasc \
	--enable-bsf=chomp \
	--enable-bsf=h264_mp4toannexb \
	--enable-bsf=mp3_header_decompress \
	\
	--enable-libmp3lame \
	--enable-libopus \
	--enable-libvpx \
	--enable-libwebp \
	--enable-libx264 \
	--enable-libx265 \
	$NVENC \
	\
	--arch=$ARCH --target-os=$OS --cross-prefix=$CROSS_COMPILE \
	--cc="$CC" --cxx="$CXX" --ld="$CXX" --prefix=$ROOT --extra-ldflags="$ELDFLAGS" \
	--enable-gpl --disable-programs --disable-doc --enable-static --disable-shared \
	--enable-small --pkg-config=pkg-config --pkg_config_flags=--static
