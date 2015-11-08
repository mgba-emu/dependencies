PROJECTS := ffmpeg imagemagick lame libepoxy libpng libvpx libzip opus qt5 sdl2 x264 xvidcore zlib
ROOT ?= /
CPPFLAGS += -I$(ROOT)/include
CFLAGS += -O3 -msse2 $(CPPFLAGS)
CXXFLAGS += -O3 -msse2 $(CPPFLAGS)
LDFLAGS += -L$(ROOT)/lib
PKG_CONFIG_LIBDIR := $(ROOT)/lib/pkgconfig
PKG_CONFIG_SYSROOT_DIR := /.
export CPPFLAGS
export CFLAGS
export CXXFLAGS
export LDFLAGS
export PKG_CONFIG_LIBDIR

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

clean: $(foreach PROJECT, $(PROJECTS),$(PROJECT)-clean)

$(foreach PROJECT, $(PROJECTS),$(PROJECT)-clean):
	-$(MAKE) -C $(subst -clean,,$@) distclean

$(foreach PROJECT, $(PROJECTS),$(PROJECT)): CONFIGURE=bash ./configure --enable-static --host=$(HOST) --prefix=$(ROOT) --disable-shared SHELL=bash $(CONFIGURE_FLAGS)
$(foreach PROJECT, $(PROJECTS),$(PROJECT)): BASEDIR=$@
$(foreach PROJECT, $(PROJECTS),$(PROJECT)): TARGET=install
$(foreach PROJECT, $(PROJECTS),$(PROJECT)):
	cd $(BASEDIR) && $(CONFIGURE) && $(MAKE) $(TARGET)

imagemagick: CONFIGURE_FLAGS=--with-quantum-depth=8 --with-x=no --with-bzlib=no LDFLAGS="$(LDFLAGS) -lws2_32"
imagemagick: libpng

ffmpeg: CONFIGURE=../buildscripts/configure-ffmpeg.sh "$(CROSS_PREFIX)" $(ROOT)
ffmpeg: lame libvpx opus x264 xvidcore

lame: CONFIGURE_FLAGS=--disable-frontend

libepoxy: CONFIGURE_FLAGS=CFLAGS="$(CFLAGS) -DEPOXY_STATIC_LIB=ON"

libpng: zlib
libpng: CONFIGURE=autoreconf --force --install && ./configure --enable-static --host=$(HOST) --prefix=$(ROOT) --disable-shared --disable-cli --enable-strip

libvpx: CONFIGURE=../buildscripts/configure-libvpx.sh "$(CROSS_PREFIX)" $(ROOT)

libzip: zlib
libzip: CONFIGURE=autoreconf --force --install && ./configure --enable-static --host=$(HOST) --prefix=$(ROOT) --disable-shared CFLAGS="$(CFLAGS) -DZIP_STATIC"

qt5: CONFIGURE=../buildscripts/configure-qt.sh "$(CROSS_PREFIX)" $(ROOT)
qt5: TARGET=all install
qt5: libpng

sdl2: CONFIGURE_FLAGS=--disable-video-x11 --disable-power

x264: CONFIGURE=./configure --enable-static --host=$(HOST) --prefix=$(ROOT) --disable-shared --disable-cli --enable-strip --enable-pic

xvidcore: CONFIGURE=./configure --host=$(HOST) --prefix=$(ROOT)
xvidcore: BASEDIR=$@/build/generic
xvidcore: TARGET=all install
xvidcore: xvidcore-clean

zlib: CONFIGURE=./configure --static --prefix=$(ROOT)

.PHONY: clean $(foreach PROJECT, $(PROJECTS),$(PROJECT)-clean) $(foreach PROJECT, $(PROJECTS),$(PROJECT))
