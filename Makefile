PROJECTS := ffmpeg imagemagick lame libepoxy libpng libvpx libzip opus qt5 sdl2 x264 xvidcore zlib
ROOT ?= /
CPPFLAGS += -I$(ROOT)/include
CFLAGS += -O3 -msse2 $(CPPFLAGS)
CXXFLAGS += -O3 -msse2 $(CPPFLAGS)
LDFLAGS += -L$(ROOT)/lib
export CPPFLAGS
export CFLAGS
export CXXFLAGS
export LDFLAGS

ifneq ($(HOST),)
CROSS_PREFIX := $(HOST)-
endif

CC := $(shell buildscripts/identify-toolchain.sh $(CROSS_PREFIX) CC)
CXX := $(shell buildscripts/identify-toolchain.sh $(CROSS_PREFIX) CXX)
AR := $(shell buildscripts/identify-toolchain.sh $(CROSS_PREFIX) AR)
RANLIB := $(shell buildscripts/identify-toolchain.sh $(CROSS_PREFIX) RANLIB)
export CC
export CXX
export AR
export RANLIB

all: $(PROJECTS)

clean: $(foreach PROJECT, $(PROJECTS),$(PROJECT)-clean)

$(foreach PROJECT, $(PROJECTS),$(PROJECT)-clean):
	-$(MAKE) -C $(subst -clean,,$@) distclean


$(foreach PROJECT, $(PROJECTS),$(PROJECT)): CONFIGURE=autoreconf --force --install && bash ./configure --enable-static --host=$(HOST) --prefix=$(ROOT) --disable-shared $(CONFIGURE_FLAGS)
$(foreach PROJECT, $(PROJECTS),$(PROJECT)): BASEDIR=$@
$(foreach PROJECT, $(PROJECTS),$(PROJECT)):
	cd $(BASEDIR) && $(CONFIGURE) && $(MAKE) install

imagemagick: CONFIGURE_FLAGS=--with-quantum-depth=8 --with-x=no --with-bzlib=no
imagemagick: libpng

ffmpeg: CONFIGURE=../buildscripts/configure-ffmpeg.sh $(CROSS_PREFIX)
ffmpeg: lame opus x264 xvidcore

lame: CONFIGURE=./configure --enable-static --host=$(HOST) --prefix=$(ROOT) --disable-shared

libpng: zlib

libzip: zlib

qt5: CONFIGURE=../buildscripts/configure-qt.sh $(CROSS_PREFIX)
qt5: libpng

sdl2: CONFIGURE_FLAGS=--disable-video-x11 --disable-power

x264: CONFIGURE=./configure --enable-static --host=$(HOST) --prefix=$(ROOT) --disable-shared --disable-cli --enable-strip

xvidcore: BASEDIR=$@/build/generic

zlib: CONFIGURE=./configure --static --prefix=$(ROOT)

.PHONY: clean $(foreach PROJECT, $(PROJECTS),$(PROJECT)-clean) $(foreach PROJECT, $(PROJECTS),$(PROJECT))
