PROJECTS := curl ffmpeg json-c lame libpng libvpx libwebp libzip lua nv-codec-headers opus qt5 sqlite3 sdl2 x264 x265 zlib
ROOT ?= /
CPPFLAGS += -I$(ROOT)/include
LDFLAGS += -L$(ROOT)/lib
PKG_CONFIG_LIBDIR := $(ROOT)/lib/pkgconfig
PKG_CONFIG_SYSROOT_DIR := /.
CMAKE_FLAGS :=

ifneq ($(HOST),)
  PROJECTS += libelf
  ifneq ($(findstring darwin,$(HOST)),)
    DARWIN := 1
    CURL_SSL := secure-transport
  else
    PROJECTS += libepoxy openssl
    CROSS_PREFIX ?= $(HOST)-
    CURL_SSL := openssl
  endif
  ifeq ($(findstring mingw,$(HOST)),)
    PROJECTS += libedit
  endif
  ifneq ($(findstring x86_64,$(HOST)),)
    ARCHFLAGS += -msse2 -msse3
    ifeq ($(DARWIN),1)
      ARCHFLAGS += -arch x86_64 -mmacosx-version-min=10.13
      LDFLAGS += -arch x86_64
      CMAKE_FLAGS += -DCMAKE_OSX_ARCHITECTURES=x86_64 -DCMAKE_OSX_DEPLOYMENT_TARGET=10.13
    endif
  else ifneq ($(findstring i686,$(HOST)),)
    ARCHFLAGS += -msse2 -mfpmath=sse
  else ifneq ($(findstring aarch64,$(HOST)),)
    ifeq ($(DARWIN),1)
      ARCHFLAGS += -arch arm64 -mmacosx-version-min=11.3
      ASFLAGS += -mmacosx-version-min=11.3
      LDFLAGS += -arch arm64
      CMAKE_FLAGS += -DCMAKE_OSX_ARCHITECTURES=arm64 -DCMAKE_OSX_DEPLOYMENT_TARGET=11.3
    endif
  endif
else
  PKG_CONFIG_LIBDIR := $(PKG_CONFIG_LIBDIR):/usr/lib/pkgconfig:/usr/lib/$(shell gcc -print-multiarch)/pkgconfig
  PROJECTS += libedit openssl
  CURL_SSL := openssl
  ifneq ($(findstring x86_64,$(shell uname -m)),)
    ARCHFLAGS += -msse2 -msse3
  endif
endif

CFLAGS += -O3 $(ARCHFLAGS) $(CPPFLAGS)
CXXFLAGS += -O3 $(ARCHFLAGS) $(CPPFLAGS)
export ASFLAGS
export CPPFLAGS
export CFLAGS
export CXXFLAGS
export LDFLAGS
export PKG_CONFIG_LIBDIR
export PKG_CONFIG_SYSROOT_DIR
export CMAKE_FLAGS

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
	-git submodule foreach --recursive git clean -dfx

CLEAN_PROJECTS = $(foreach PROJECT, $(PROJECTS),clean-$(PROJECT))
CUSTOM_PROJECTS = curl lua luajit sdl2
CUSTOM_CLEAN = clean-qt5 clean-luajit

$(foreach PROJECT, $(filter-out $(CUSTOM_CLEAN),$(CLEAN_PROJECTS)),$(PROJECT)):
	-$(MAKE) -C $(subst clean-,,$@) distclean

$(foreach PROJECT, $(PROJECTS),$(PROJECT)): AUTORECONF=[ ! -r configure.ac -a ! -r configure.in ] || autoreconf --force --install
$(foreach PROJECT, $(PROJECTS),$(PROJECT)): CONFIGURE=bash ./configure --enable-static --host=$(HOST) --prefix=$(ROOT) --disable-shared SHELL=bash $(CONFIGURE_FLAGS)
$(foreach PROJECT, $(PROJECTS),$(PROJECT)): BASEDIR=$@
$(foreach PROJECT, $(PROJECTS),$(PROJECT)): TARGET=all
$(foreach PROJECT, $(PROJECTS),$(PROJECT)): INSTALL=install
$(foreach PROJECT, $(filter-out $(CUSTOM_PROJECTS),$(PROJECTS)),$(PROJECT)):
	cd $(BASEDIR) && $(AUTORECONF) && $(CONFIGURE) && $(MAKE) $(TARGET) && $(MAKE) $(INSTALL)

curl: $(CURL_SSL) zlib
	cd curl && ../buildscripts/configure-curl.sh "$(CMAKE_TOOLCHAIN_FILE)" $(ROOT) && cd build && $(MAKE) install

ffmpeg: CONFIGURE=../buildscripts/configure-ffmpeg.sh "$(CROSS_PREFIX)" $(ROOT)
ffmpeg: lame libpng libvpx libwebp nv-codec-headers opus x264 x265 zlib
ffmpeg: clean-ffmpeg

json-c: CONFIGURE=cmake . -DBUILD_STATIC_LIBS=ON -DBUILD_SHARED_LIBS=OFF -DCMAKE_TOOLCHAIN_FILE="$(CMAKE_TOOLCHAIN_FILE)" -DCMAKE_INSTALL_PREFIX="$(ROOT)" $(CMAKE_FLAGS)

lame: AUTORECONF=:
lame: CONFIGURE_FLAGS=--disable-frontend

libelf: CONFIGURE=./configure --enable-static --host=$(HOST) --prefix=$(ROOT) --disable-shared

libepoxy: CONFIGURE_FLAGS=CFLAGS="$(CFLAGS) -DEPOXY_STATIC_LIB=ON"

libpng: zlib
libpng: CONFIGURE=./configure --enable-static --host=$(HOST) --prefix=$(ROOT) --disable-shared --disable-cli --enable-strip

libvpx: CONFIGURE=../buildscripts/configure-libvpx.sh "$(CROSS_PREFIX)" $(ROOT)
libvpx: MAKEFLAGS+=-j1
libvpx: clean-libvpx

libwebp: CONFIGURE=./configure --enable-static --host=$(HOST) --prefix=$(ROOT) --disable-shared --enable-libwebpmux --disable-libwebpdemux

libzip: zlib
libzip: CONFIGURE=../buildscripts/configure-libzip.sh "$(CMAKE_TOOLCHAIN_FILE)" $(ROOT)

lua:
	cd lua && $(MAKE) CFLAGS="$(CFLAGS)" CC="$(CC)" AR="$(AR) rc" RANLIB="$(RANLIB)" liblua.a && cp liblua.a $(ROOT)/lib && cp lua*.h lauxlib.h $(ROOT)/include

luajit:
	cd luajit && $(MAKE) $(shell buildscripts/lua-flags.sh "$(CROSS_PREFIX)") PREFIX="$(ROOT)" install

clean-luajit:
	$(MAKE) -C luajit clean

nv-codec-headers: CONFIGURE=:
nv-codec-headers: INSTALL=PREFIX="$(ROOT)" install

openssl: zlib
openssl: CONFIGURE=../buildscripts/configure-openssl.sh "$(CROSS_PREFIX)" $(ROOT)
openssl: INSTALL=install_sw

opus: CFLAGS+=-D_FORTIFY_SOURCE=0
opus: CONFIGURE=autoreconf --force --install && ./configure --enable-static --host=$(HOST) --prefix=$(ROOT) --disable-shared --disable-extra-programs

qt5: CONFIGURE=../buildscripts/configure-qt.sh "$(CROSS_PREFIX)" $(ROOT)
qt5: libpng openssl sqlite3
qt5: TARGET=first

clean-qt5:
	(cd qt5 && git clean -dfx && git submodule foreach git clean -dfx)

sdl2: CONFIGURE=cmake . -DSDL_STATIC=ON -DSDL_SHARED=OFF -DLIBC=ON -DCMAKE_TOOLCHAIN_FILE="$(CMAKE_TOOLCHAIN_FILE)" -DCMAKE_INSTALL_PREFIX="$(ROOT)" $(CMAKE_FLAGS)

x264: CONFIGURE=./configure --enable-static --host=$(HOST) --prefix=$(ROOT) --disable-cli --enable-strip --enable-pic --cross-prefix=$(CROSS_PREFIX) --extra-asflags="$(ASFLAGS)"

x265: CONFIGURE=../buildscripts/configure-x265.sh "$(CMAKE_TOOLCHAIN_FILE)" $(ROOT)

zlib: CONFIGURE=./configure --static --prefix=$(ROOT)

secure-transport:
.PHONY: clean $(foreach PROJECT, $(PROJECTS),$(PROJECT)-clean) $(foreach PROJECT, $(PROJECTS),$(PROJECT)) secure-transport
