FROM ubuntu:bionic

RUN apt-get update && \
    apt-get install -y --no-install-recommends autoconf automake \
        ca-certificates cmake g++ g++-mingw-w64-x86-64 git libtool make \
        markdown nasm pkg-config python wine-development yasm && \
    apt-get autoremove -y && apt-get clean

COPY libraries /root/dependencies/
COPY patches /root/dependencies/patches
COPY buildscripts /root/dependencies/buildscripts
WORKDIR /root/dependencies

RUN ROOT=/opt/win64 HOST=x86_64-w64-mingw32 make -j4 && cd .. && rm -rf dependencies

COPY dockerfiles/windows-w64/CMakeToolchain.txt /opt/win64
COPY licenses /opt/licenses
RUN chmod -R go+r /opt && \
    useradd mgba -m
VOLUME /home/mgba/src
USER mgba
WORKDIR /home/mgba/src
ENV BUILD_DIR=build-win64
CMD mkdir -p "$BUILD_DIR" && cd "$BUILD_DIR" && \
    cmake .. \
        -DEXTRA_LICENSES=$(ls /opt/licenses | tr $'\n' ';') \
        -DCMAKE_TOOLCHAIN_FILE=/opt/win64/CMakeToolchain.txt \
        -DBUILD_SHARED=OFF -DBUILD_STATIC=ON $CMAKE_FLAGS && \
    make install DESTDIR=install
