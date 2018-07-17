FROM ubuntu:xenial

RUN apt-get update && \
    apt-get install -y --no-install-recommends automake bzip2 ca-certificates \
        cmake curl gcc g++ git libc6-dev liblz4-dev make pkgconf xz-utils \
        zlib1g-dev && \
    apt-get autoremove -y && apt-get clean

WORKDIR /root
RUN curl -L \
    -O https://github.com/devkitPro/buildscripts/releases/download/devkitA64_r11/devkitA64_r11-2-linux.tar.xz
RUN mkdir -p /opt/devkitPro/libnx && \
    tar xf devkitA64*.tar.* -C /opt/devkitPro && \
    rm -f *.tar.*

ENV DEVKITPRO=/opt/devkitPro
ENV DEVKITA64=$DEVKITPRO/devkitA64

RUN git clone https://github.com/devkitPro/general-tools.git -b v1.0.2 && \
    (cd general-tools && ./autogen.sh && ./configure --prefix=$DEVKITA64 && make install) && rm -rf general-tools

RUN git clone https://github.com/switchbrew/switch-tools.git -b v1.4.1 && \
    (cd switch-tools && ./autogen.sh && ./configure --prefix=$DEVKITA64 && make install) && rm -rf switch-tools

RUN git clone https://github.com/switchbrew/libnx.git -b v1.3.0 && \
    (cd libnx && make install) && rm -rf libnx

RUN apt-get autoremove -y automake bzip2 curl gcc g++ libc6-dev pkgconf

RUN useradd mgba -m
VOLUME /home/mgba/src
USER mgba
WORKDIR /home/mgba/src
ENV BUILD_DIR=build-switch
CMD mkdir -p "$BUILD_DIR" && cd "$BUILD_DIR" && cmake .. -DCMAKE_TOOLCHAIN_FILE=../src/platform/switch/CMakeToolchain.txt $CMAKE_FLAGS && make install DESTDIR=install
