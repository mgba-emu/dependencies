FROM ubuntu:xenial

RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential bzip2 \
        ca-certificates cmake curl git zip && \
    apt-get autoremove -y && apt-get clean

WORKDIR /root
RUN curl -L \
    -O https://github.com/devkitPro/buildscripts/releases/download/devkitARM_r48/devkitARM_r48-linux.tar.xz \
    -O https://github.com/smealum/ctrulib/releases/download/v1.5.0/libctru-1.5.0.tar.bz2
RUN mkdir -p /opt/devkitPro/libctru && \
    tar xf devkitARM*.tar.* -C /opt/devkitPro && \
    tar xf libctru-*.tar.* -C /opt/devkitPro/libctru

ENV DEVKITPRO=/opt/devkitPro
ENV DEVKITARM=/opt/devkitPro/devkitARM

RUN git clone https://github.com/fincs/citro3d.git -b v1.4.0
RUN (cd citro3d && make install) && rm -rf citro3d

RUN git clone --recursive https://github.com/Steveice10/bannertool.git -b 1.0.0
RUN (cd bannertool && make && install output/*/bannertool $DEVKITARM/bin) && rm -rf bannertool

RUN git clone https://github.com/profi200/Project_CTR.git
RUN (cd Project_CTR/makerom && make && install makerom $DEVKITARM/bin) && rm -rf Project_CTR

RUN useradd mgba -m
VOLUME /home/mgba/src
USER mgba
WORKDIR /home/mgba/src
ENV BUILD_DIR=build-3ds
CMD mkdir -p "$BUILD_DIR" && cd "$BUILD_DIR" && cmake .. -DCMAKE_TOOLCHAIN_FILE=../src/platform/3ds/CMakeToolchain.txt $CMAKE_FLAGS && make install DESTDIR=install
