FROM ubuntu:xenial

RUN apt-get update && \
    apt-get install -y --no-install-recommends automake bzip2 ca-certificates \
        cmake curl gcc g++ git libc6-dev make xz-utils zip && \
    apt-get autoremove -y && apt-get clean

WORKDIR /root
RUN curl -L \
    -O https://github.com/devkitPro/buildscripts/releases/download/devkitARM_r48/devkitARM_r48-linux.tar.xz \
    -O https://github.com/smealum/ctrulib/releases/download/v1.5.0/libctru-1.5.0.tar.bz2
RUN mkdir -p /opt/devkitPro/libctru && \
    tar xf devkitARM*.tar.* -C /opt/devkitPro && \
    tar xf libctru-*.tar.* -C /opt/devkitPro/libctru && \
    rm -f *.tar.*

ENV DEVKITPRO=/opt/devkitPro
ENV DEVKITARM=/opt/devkitPro/devkitARM

RUN git clone https://github.com/fincs/citro3d.git -b v1.4.0 && \
    (cd citro3d && make install) && rm -rf citro3d

RUN git clone --recursive https://github.com/Steveice10/bannertool.git -b 1.0.0 && \
    (cd bannertool && make && install output/*/bannertool $DEVKITARM/bin) && rm -rf bannertool

RUN git clone https://github.com/profi200/Project_CTR.git && \
    (cd Project_CTR/makerom && make && install makerom $DEVKITARM/bin) && rm -rf Project_CTR

RUN git clone https://github.com/devkitPro/general-tools.git -b v1.0.2 && \
    (cd general-tools && ./autogen.sh && ./configure --prefix=$DEVKITARM && make install) && rm -rf general-tools

RUN git clone https://github.com/fincs/picasso.git && \
    (cd picasso && ./autogen.sh && ./configure --prefix=$DEVKITARM && make install) && rm -rf picasso

RUN git clone https://github.com/devkitPro/3dstools.git && \
    (cd 3dstools && ./autogen.sh && ./configure --prefix=$DEVKITARM && make install) && rm -rf 3dstools

RUN apt-get autoremove -y bzip2 curl gcc g++ libc6-dev zip

RUN useradd mgba -m
VOLUME /home/mgba/src
USER mgba
WORKDIR /home/mgba/src
ENV BUILD_DIR=build-3ds
CMD mkdir -p "$BUILD_DIR" && cd "$BUILD_DIR" && cmake .. -DCMAKE_TOOLCHAIN_FILE=../src/platform/3ds/CMakeToolchain.txt $CMAKE_FLAGS && make install DESTDIR=install
