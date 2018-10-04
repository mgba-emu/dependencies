FROM ubuntu:bionic

RUN dpkg --add-architecture i386 && apt-get update && \
    apt-get install -y --no-install-recommends autoconf automake \
        ca-certificates cmake dos2unix g++ g++-mingw-w64-i686 git libtool \
        make markdown nasm pkg-config python wine32 wine-stable:i386 yasm && \
    apt-get autoremove -y && apt-get clean

COPY libraries /root/dependencies/
WORKDIR /root/dependencies

RUN ROOT=/opt/win32 HOST=i686-w64-mingw32 make -j4 && cd .. && rm -rf dependencies

COPY dockerfiles/windows-w32/CMakeToolchain.txt /opt/win32
COPY licenses /opt/licenses
COPY binaries/inno-setup /opt/inno-setup
RUN chmod -R go+r /opt && \
    find /opt -type d -exec chmod go+x {} \; && \
    useradd mgba -m
VOLUME /home/mgba/src
USER mgba
WORKDIR /home/mgba/src
ENV BUILD_DIR=build-win32
CMD mkdir -p "$BUILD_DIR" && cd "$BUILD_DIR" && \
    cmake .. \
        -DEXTRA_LICENSES=$(ls /opt/licenses/* | tr $'\n' ';') \
        -DCMAKE_TOOLCHAIN_FILE=/opt/win32/CMakeToolchain.txt \
        -DBUILD_SHARED=OFF -DBUILD_STATIC=ON $CMAKE_FLAGS && \
    make install DESTDIR=install
