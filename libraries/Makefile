PROJECTS := ffmpeg imagemagick lame libelf libepoxy libpng libvpx libzip opus qt5 sqlite3 sdl2 x264 xvidcore zlib
ROOT ?= /
CPPFLAGS += -I$(ROOT)/include
CFLAGS += -O3 -msse2 $(CPPFLAGS) -ffat-lto-objects
CXXFLAGS += -O3 -msse2 $(CPPFLAGS)
LDFLAGS += -L$(ROOT)/lib
PKG_CONFIG_LIBDIR := $(ROOT)/lib/pkgconfig
PKG_CONFIG_SYSROOT_DIR := /.
export CPPFLAGS
export CFLAGS
export CXXFLAGS
export LDFLAGS
export PKG_CONFIG_LIBDIR
export PKG_CONFIG_SYSROOT_DIR

ifneq ($(HOST),)
CROSS_PREFIX := $(HOST)-
endif

CC := $(shell buildscripts/identify-toolchain.sh $(CROSS_PREFIX) CC)
CXX := $(shell buildscripts/identify-toolchain.sh $(CROSS_PREFIX) CXX)
AR := $(shell buildscripts/identify-toolchain.sh $(CROSS_PREFIX) AR)
RANLIB := $(shell buildscripts/identify-toolchain.sh $(CROSS_PREFIX) RANLIB)
STRIP := $(shell buildscripts/identify-toolchain.sh $(CROSS_PREFIX) STRIP)
export CC
export CXX
export AR
export RANLIB
export STRIP

all: $(PROJECTS)

clean: $(foreach PROJECT, $(PROJECTS),clean-$(PROJECT))

CLEAN_PROJECTS = $(foreach PROJECT, $(PROJECTS),clean-$(PROJECT))
CUSTOM_CLEAN = clean-qt5

$(foreach PROJECT, $(filter-out $(CUSTOM_CLEAN),$(CLEAN_PROJECTS)),$(PROJECT)):
	-$(MAKE) -C $(subst clean-,,$@) distclean

$(foreach PROJECT, $(PROJECTS),$(PROJECT)): CONFIGURE=bash ./configure --enable-static --host=$(HOST) --prefix=$(ROOT) --disable-shared SHELL=bash $(CONFIGURE_FLAGS)
$(foreach PROJECT, $(PROJECTS),$(PROJECT)): BASEDIR=$@
$(foreach PROJECT, $(PROJECTS),$(PROJECT)): TARGET=all
$(foreach PROJECT, $(PROJECTS),$(PROJECT)):
	cd $(BASEDIR) && $(CONFIGURE) && $(MAKE) $(TARGET) && $(MAKE) install

imagemagick: CONFIGURE_FLAGS=--with-quantum-depth=8 --with-x=no --with-bzlib=no --without-magick-plus-plus --without-threads LDFLAGS=-lws2_32
imagemagick: libpng

ffmpeg: CONFIGURE=../buildscripts/configure-ffmpeg.sh "$(CROSS_PREFIX)" $(ROOT)
ffmpeg: lame libvpx opus x264 xvidcore
ffmpeg: clean-ffmpeg

lame: CONFIGURE_FLAGS=--disable-frontend

libelf: CONFIGURE=autoreconf --force --install && ./configure --enable-static --host=$(HOST) --prefix=$(ROOT) --disable-shared

libepoxy: CONFIGURE_FLAGS=CFLAGS="$(CFLAGS) -DEPOXY_STATIC_LIB=ON"

libpng: zlib
libpng: CONFIGURE=autoreconf --force --install && ./configure --enable-static --host=$(HOST) --prefix=$(ROOT) --disable-shared --disable-cli --enable-strip

libvpx: CONFIGURE=../buildscripts/configure-libvpx.sh "$(CROSS_PREFIX)" $(ROOT)
libvpx: MAKEFLAGS+=-j1
libvpx: clean-libvpx

libzip: zlib
libzip: CONFIGURE=autoreconf --force --install && ./configure --enable-static --host=$(HOST) --prefix=$(ROOT) --disable-shared CFLAGS="$(CFLAGS) -DZIP_STATIC"

opus: CONFIGURE=autoreconf --force --install && ./configure --enable-static --host=$(HOST) --prefix=$(ROOT) --disable-shared

qt5: CONFIGURE=../buildscripts/configure-qt.sh "$(CROSS_PREFIX)" $(ROOT)
qt5: libpng sqlite3
qt5: TARGET=first

clean-qt5:
	(cd qt5 && git clean -dfx && git submodule foreach git clean -dfx)

sdl2: CONFIGURE_FLAGS=--disable-video-x11 --disable-power

x264: CONFIGURE=./configure --enable-static --host=$(HOST) --prefix=$(ROOT) --disable-cli --enable-strip --enable-pic --cross-prefix=$(CROSS_PREFIX)

xvidcore: CONFIGURE=./configure --host=$(HOST) --prefix=$(ROOT)
xvidcore: BASEDIR=$@/build/generic
xvidcore: TARGET=clean all
xvidcore: MAKEFLAGS=
xvidcore: xvidcore-clean

zlib: CONFIGURE=./configure --static --prefix=$(ROOT)

.PHONY: clean $(foreach PROJECT, $(PROJECTS),$(PROJECT)-clean) $(foreach PROJECT, $(PROJECTS),$(PROJECT))
