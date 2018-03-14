FROM ubuntu:xenial

RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential bzip2 \
        ca-certificates cmake curl git zip && \
    apt-get autoremove -y && apt-get clean

WORKDIR /root
RUN curl -L \
    -O https://downloads.sourceforge.net/project/devkitpro/devkitARM/devkitARM_r47/devkitARM_r47-x86_64-linux.tar.bz2 \
    -O https://downloads.sourceforge.net/project/devkitpro/libctru/1.4.0/libctru-1.4.0.tar.bz2 \
    -O https://downloads.sourceforge.net/project/devkitpro/citro3d/1.3.1/citro3d-1.3.1.tar.bz2
RUN mkdir -p /opt/devkitPro/libctru && \
    tar xf devkitARM*.tar.* -C /opt/devkitPro && \
    tar xf libctru-*.tar.* -C /opt/devkitPro/libctru && \
    tar xf citro3d-*.tar.* -C /opt/devkitPro/libctru

ENV DEVKITPRO=/opt/devkitPro
ENV DEVKITARM=/opt/devkitPro/devkitARM

RUN git clone --recursive https://github.com/Steveice10/bannertool.git
RUN (cd bannertool && make && install output/*/bannertool $DEVKITARM/bin)

RUN git clone https://github.com/profi200/Project_CTR.git
RUN (cd Project_CTR/makerom && make && install makerom $DEVKITARM/bin)

RUN useradd mgba -m
VOLUME /home/mgba/src
USER mgba
WORKDIR /home/mgba/src
ENV BUILD_DIR=build-3ds
CMD mkdir -p "$BUILD_DIR" && cd "$BUILD_DIR" && cmake .. -DCMAKE_TOOLCHAIN_FILE=../src/platform/3ds/CMakeToolchain.txt -DCMAKE_INSTALL_PREFIX=// $CMAKE_FLAGS && make install DESTDIR=install
