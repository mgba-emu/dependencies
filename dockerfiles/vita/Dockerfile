FROM ubuntu:xenial

RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential bzip2 \
        ca-certificates cmake curl git m4 patch texinfo wget xz-utils && \
    apt-get autoremove -y && apt-get clean

WORKDIR /root
ENV VITASDK=/opt/vitasdk
ENV PATH=$VITASDK/bin:$PATH

RUN git clone https://github.com/vitasdk/buildscripts
RUN mkdir -p buildscripts/build/downloads
COPY binaries/libelf-0.8.13.tar.gz buildscripts/build/downloads
RUN cd buildscripts/build && \
    cmake .. && make -j2 && mv vitasdk $VITASDK && \
    cd .. && rm -rf build
RUN vdpm zlib && vdpm bzip2 && vdpm libzip && vdpm libpng && vdpm libvita2d

COPY dockerfiles/vita/vita.cmake.patch /root
RUN cd /opt/vitasdk/share && patch -p2 < /root/vita.cmake.patch

RUN useradd mgba -m
VOLUME /home/mgba/src
USER mgba
WORKDIR /home/mgba/src
ENV BUILD_DIR=build-vita
CMD mkdir -p "$BUILD_DIR" && cd "$BUILD_DIR" && cmake .. -DCMAKE_TOOLCHAIN_FILE=../src/platform/psp2/CMakeToolchain.vitasdk $CMAKE_FLAGS && make install DESTDIR=install
