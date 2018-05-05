FROM ubuntu:xenial

RUN apt-get update && \
    apt-get install -y --no-install-recommends bzip2 ca-certificates cmake \
        curl git make && \
    apt-get autoremove -y && apt-get clean

WORKDIR /root
RUN curl -L \
    -O https://github.com/devkitPro/buildscripts/releases/download/devkitPPC_r29-1/devkitPPC_r29-1-x86_64-linux.tar.bz2 \
    -O https://github.com/devkitPro/libogc/releases/download/v1.8.17/libogc-1.8.17.tar.bz2 \
    -O https://github.com/devkitPro/libfat/releases/download/v1.1.2/libfat-ogc-1.1.2.tar.bz2
RUN mkdir -p /opt/devkitPro/libogc && \
    tar xf devkitPPC*.tar.* -C /opt/devkitPro && \
    tar xf libogc-*.tar.* -C /opt/devkitPro/libogc && \
    tar xf libfat-*.tar.* -C /opt/devkitPro/libogc

ENV DEVKITPRO=/opt/devkitPro
ENV DEVKITPPC=/opt/devkitPro/devkitPPC

RUN useradd mgba -m
VOLUME /home/mgba/src
USER mgba
WORKDIR /home/mgba/src
ENV BUILD_DIR=build-wii
CMD mkdir -p "$BUILD_DIR" && cd "$BUILD_DIR" && cmake .. -DCMAKE_TOOLCHAIN_FILE=../src/platform/wii/CMakeToolchain.txt $CMAKE_FLAGS && make install DESTDIR=install
