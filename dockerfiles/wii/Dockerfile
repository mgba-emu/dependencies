FROM ubuntu:xenial

RUN apt-get update && \
    apt-get install -y --no-install-recommends automake bzip2 ca-certificates \
        cmake curl gcc g++ git libc6-dev libfreeimage-dev libtool make \
        mesa-common-dev xz-utils && \
    apt-get autoremove -y && apt-get clean

WORKDIR /root
RUN curl -L \
    -O https://github.com/devkitPro/buildscripts/releases/download/devkitPPC_r30/devkitPPC_r30-linux.tar.xz \
    -O https://github.com/devkitPro/libogc/releases/download/v1.8.18/libogc-1.8.18.tar.bz2 \
    -O https://github.com/devkitPro/libfat/releases/download/v1.1.3/libfat-ogc-1.1.3.tar.bz2
RUN mkdir -p /opt/devkitPro/libogc && \
    tar xf devkitPPC*.tar.* -C /opt/devkitPro && \
    tar xf libogc-*.tar.* -C /opt/devkitPro/libogc && \
    tar xf libfat-*.tar.* -C /opt/devkitPro/libogc && \
    rm -f *.tar.*

ENV DEVKITPRO=/opt/devkitPro
ENV DEVKITPPC=/opt/devkitPro/devkitPPC

RUN git clone https://github.com/devkitPro/general-tools.git -b v1.0.2 && \
    (cd general-tools && ./autogen.sh && ./configure --prefix=$DEVKITPPC && make install) && rm -rf general-tools

RUN git clone https://github.com/devkitPro/gamecube-tools.git -b v1.0.2 && \
    (cd gamecube-tools && ./autogen.sh && ./configure --prefix=$DEVKITPPC && make install) && rm -rf gamecube-tools

RUN apt-get autoremove -y bzip2 curl gcc g++ libc6-dev libtool mesa-common-dev

RUN useradd mgba -m
VOLUME /home/mgba/src
USER mgba
WORKDIR /home/mgba/src
ENV BUILD_DIR=build-wii
CMD mkdir -p "$BUILD_DIR" && cd "$BUILD_DIR" && cmake .. -DCMAKE_TOOLCHAIN_FILE=../src/platform/wii/CMakeToolchain.txt $CMAKE_FLAGS && make install DESTDIR=install
