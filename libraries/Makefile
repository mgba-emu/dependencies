PROJECTS := ffmpeg lame libelf libepoxy libpng libvpx libwebp libzip luajit nv-codec-headers openssl opus qt5 sqlite3 sdl2 x264 zlib
ROOT ?= /
CPPFLAGS += -I$(ROOT)/include
LDFLAGS += -L$(ROOT)/lib
PKG_CONFIG_LIBDIR := $(ROOT)/lib/pkgconfig
PKG_CONFIG_SYSROOT_DIR := /.

ifneq ($(HOST),)
CROSS_PREFIX := $(HOST)-
ifneq ($(findstring x86_64,$(HOST)),)
ARCHFLAGS += -msse2 -msse3 -msse4
else ifneq ($(findstring i686,$(HOST)),)
ARCHFLAGS += -msse2
endif
endif

CFLAGS += -O3 $(ARCHFLAGS) $(CPPFLAGS) -ffat-lto-objects
CXXFLAGS += -O3 $(ARCHFLAGS) $(CPPFLAGS)
export CPPFLAGS
export CFLAGS
export CXXFLAGS
export LDFLAGS
export PKG_CONFIG_LIBDIR
export PKG_CONFIG_SYSROOT_DIR

CC := $(shell buildscripts/identify-toolchain.sh "$(CROSS_PREFIX)" CC)
CXX := $(shell buildscripts/identify-toolchain.sh "$(CROSS_PREFIX)" CXX)
AR := $(shell buildscripts/identify-toolchain.sh "$(CROSS_PREFIX)" AR)
RANLIB := $(shell buildscripts/identify-toolchain.sh "$(CROSS_PREFIX)" RANLIB)
STRIP := $(shell buildscripts/identify-toolchain.sh "$(CROSS_PREFIX)" STRIP)
export CC
export CXX
export AR
export RANLIB
export STRIP

all: $(PROJECTS)

clean: $(foreach PROJECT, $(PROJECTS),clean-$(PROJECT))

CLEAN_PROJECTS = $(foreach PROJECT, $(PROJECTS),clean-$(PROJECT))
CUSTOM_PROJECTS = luajit
CUSTOM_CLEAN = clean-qt5 clean-luajit

$(foreach PROJECT, $(filter-out $(CUSTOM_CLEAN),$(CLEAN_PROJECTS)),$(PROJECT)):
	-$(MAKE) -C $(subst clean-,,$@) distclean

$(foreach PROJECT, $(PROJECTS),$(PROJECT)): CONFIGURE=bash ./configure --enable-static --host=$(HOST) --prefix=$(ROOT) --disable-shared SHELL=bash $(CONFIGURE_FLAGS)
$(foreach PROJECT, $(PROJECTS),$(PROJECT)): BASEDIR=$@
$(foreach PROJECT, $(PROJECTS),$(PROJECT)): TARGET=all
$(foreach PROJECT, $(filter-out $(CUSTOM_PROJECTS),$(PROJECTS)),$(PROJECT)):
	cd $(BASEDIR) && $(CONFIGURE) && $(MAKE) $(TARGET) && $(MAKE) install

ffmpeg: CONFIGURE=../buildscripts/configure-ffmpeg.sh "$(CROSS_PREFIX)" $(ROOT)
ffmpeg: lame libvpx libwebp nv-codec-headers opus x264
ffmpeg: clean-ffmpeg

lame: CONFIGURE_FLAGS=--disable-frontend

libelf: CONFIGURE=autoreconf --force --install && ./configure --enable-static --host=$(HOST) --prefix=$(ROOT) --disable-shared

libepoxy: CONFIGURE_FLAGS=CFLAGS="$(CFLAGS) -DEPOXY_STATIC_LIB=ON"

libpng: zlib
libpng: CONFIGURE=autoreconf --force --install && ./configure --enable-static --host=$(HOST) --prefix=$(ROOT) --disable-shared --disable-cli --enable-strip

libvpx: CONFIGURE=../buildscripts/configure-libvpx.sh "$(CROSS_PREFIX)" $(ROOT)
libvpx: MAKEFLAGS+=-j1
libvpx: clean-libvpx

libwebp: CONFIGURE=autoreconf --force --install && ./configure --enable-static --host=$(HOST) --prefix=$(ROOT) --disable-shared --enable-libwebpmux --disable-cwebp --disable-dwebp

libzip: zlib
libzip: CONFIGURE=../buildscripts/configure-libzip.sh

luajit:
	cd luajit && make $(shell buildscripts/lua-flags.sh "$(CROSS_PREFIX)") PREFIX="$(ROOT)" install

clean-luajit:
	make -C luajit clean

nv-codec-headers:
	cd nv-codec-headers && make PREFIX="$(ROOT)" install

openssl: zlib
openssl: CONFIGURE=../buildscripts/configure-openssl.sh "$(CROSS_PREFIX)" $(ROOT)

opus: CFLAGS+=-D_FORTIFY_SOURCE=0
opus: CONFIGURE=autoreconf --force --install && ./configure --enable-static --host=$(HOST) --prefix=$(ROOT) --disable-shared --disable-extra-programs

qt5: CONFIGURE=../buildscripts/configure-qt.sh "$(CROSS_PREFIX)" $(ROOT)
qt5: libpng openssl sqlite3
qt5: TARGET=first

clean-qt5:
	(cd qt5 && git clean -dfx && git submodule foreach git clean -dfx)

sdl2: CONFIGURE_FLAGS=--disable-video-x11 --disable-power

x264: CONFIGURE=./configure --enable-static --host=$(HOST) --prefix=$(ROOT) --disable-cli --enable-strip --enable-pic --cross-prefix=$(CROSS_PREFIX)

zlib: CONFIGURE=./configure --static --prefix=$(ROOT)

.PHONY: clean $(foreach PROJECT, $(PROJECTS),$(PROJECT)-clean) $(foreach PROJECT, $(PROJECTS),$(PROJECT))
