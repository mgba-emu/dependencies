FROM ubuntu:bionic

RUN dpkg --add-architecture i386 && apt-get update && \
    apt-get install -y --no-install-recommends autoconf automake \
        ca-certificates ccache cmake dos2unix g++ g++-mingw-w64-i686 git \
        lib32gcc-7-dev libc6-dev:i386 libc6-dev-i386 libtool make markdown \
        nasm pkg-config python wine32 wine-stable:i386 yasm && \
    apt-get autoremove -y && apt-get clean

RUN mkdir -p /opt/win32
COPY dockerfiles/windows-w32/CMakeToolchain.txt /opt/win32
COPY libraries /root/dependencies/
WORKDIR /root/dependencies

RUN ROOT=/opt/win32 HOST=i686-w64-mingw32 CMAKE_TOOLCHAIN_FILE=/opt/win32/CMakeToolchain.txt make -j4 && cd .. && rm -rf dependencies

COPY licenses /opt/licenses
COPY binaries/inno-setup /opt/inno-setup
RUN chmod -R go+r /opt && \
    find /opt -type d -exec chmod go+x {} \;
RUN update-ccache-symlinks
RUN useradd mgba -m
RUN mkdir -p /home/mgba/.ccache && chown mgba:mgba /home/mgba/.ccache
VOLUME /home/mgba/src /home/mgba/.ccache
USER mgba
WORKDIR /home/mgba/src
ENV PATH=/usr/lib/ccache:$PATH
ENV BUILD_DIR=build-win32
CMD mkdir -p "$BUILD_DIR" && cd "$BUILD_DIR" && \
    cmake .. \
        -DEXTRA_LICENSES=$(ls /opt/licenses/* | tr $'\n' ';') \
        -DCMAKE_TOOLCHAIN_FILE=/opt/win32/CMakeToolchain.txt \
        -DBUILD_SHARED=OFF -DBUILD_STATIC=ON $CMAKE_FLAGS && \
    make install DESTDIR=install
