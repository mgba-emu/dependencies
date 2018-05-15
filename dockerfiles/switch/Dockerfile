FROM ubuntu:xenial

RUN apt-get update && \
    apt-get install -y --no-install-recommends bzip2 ca-certificates cmake \
        curl git make xz-utils && \
    apt-get autoremove -y && apt-get clean

WORKDIR /root
RUN curl -L \
    -O https://github.com/devkitPro/buildscripts/releases/download/devkitA64_r9/devkitA64_r9-linux.tar.xz
RUN mkdir -p /opt/devkitPro/libnx && \
    tar xf devkitA64*.tar.* -C /opt/devkitPro

ENV DEVKITPRO=/opt/devkitPro
ENV DEVKITA64=/opt/devkitPro/devkitA64

RUN git clone https://github.com/switchbrew/libnx.git && cd libnx && make install

RUN useradd mgba -m
VOLUME /home/mgba/src
USER mgba
WORKDIR /home/mgba/src
ENV BUILD_DIR=build-switch
CMD mkdir -p "$BUILD_DIR" && cd "$BUILD_DIR" && cmake .. -DCMAKE_TOOLCHAIN_FILE=../src/platform/switch/CMakeToolchain.txt $CMAKE_FLAGS && make install DESTDIR=install
