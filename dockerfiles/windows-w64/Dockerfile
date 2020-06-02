FROM ubuntu:bionic

RUN dpkg --add-architecture i386 && apt-get update && \
    apt-get install -y --no-install-recommends autoconf automake \
        ca-certificates ccache cmake dos2unix g++ g++-mingw-w64-x86-64 git \
        libtool make markdown nasm pkg-config python wine32 wine-stable:i386 \
        yasm && \
    apt-get autoremove -y && apt-get clean

COPY libraries /root/dependencies/
WORKDIR /root/dependencies

RUN ROOT=/opt/win64 HOST=x86_64-w64-mingw32 make -j4 && cd .. && rm -rf dependencies

COPY dockerfiles/windows-w64/CMakeToolchain.txt /opt/win64
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
ENV BUILD_DIR=build-win64
CMD mkdir -p "$BUILD_DIR" && cd "$BUILD_DIR" && \
    cmake .. \
        -DEXTRA_LICENSES=$(ls /opt/licenses/* | tr $'\n' ';') \
        -DCMAKE_TOOLCHAIN_FILE=/opt/win64/CMakeToolchain.txt \
        -DBUILD_SHARED=OFF -DBUILD_STATIC=ON $CMAKE_FLAGS && \
    make install DESTDIR=install
