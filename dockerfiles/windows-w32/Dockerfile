FROM ubuntu:noble

ENV DEBIAN_FRONTEND=noninteractive
RUN dpkg --add-architecture i386 && apt-get update && \
    apt-get install -y --no-install-recommends libc6:i386 && \
    apt-get install -y --no-install-recommends autoconf automake \
        ca-certificates ccache cmake curl dos2unix gcc-multilib g++ \
        g++-mingw-w64-i686 git libtool make markdown nasm patch pkg-config \
        python-is-python3 wine wine32 xutils-dev yasm && \
    curl -Lo /tmp/mingw-dev.deb \
        https://mirrors.kernel.org/ubuntu/pool/universe/m/mingw-w64/mingw-w64-i686-dev_12.0.0-3_all.deb && \
    curl -Lo /tmp/mingw-common.deb \
        https://mirrors.kernel.org/ubuntu/pool/universe/m/mingw-w64/mingw-w64-common_12.0.0-3_all.deb && \
    dpkg -i /tmp/mingw-common.deb && \
    dpkg -i /tmp/mingw-dev.deb && \
    apt-get autoremove -y && apt-get clean

RUN update-alternatives --set i686-w64-mingw32-gcc /usr/bin/i686-w64-mingw32-gcc-posix && \
    update-alternatives --set i686-w64-mingw32-g++ /usr/bin/i686-w64-mingw32-g++-posix
RUN mkdir -p /opt/win32
COPY dockerfiles/windows-w32/CMakeToolchain.txt /opt/win32
COPY libraries /root/dependencies/
WORKDIR /root/dependencies
RUN find x265 -name .git -delete

RUN ROOT=/opt/win32 HOST=i686-w64-mingw32 CMAKE_TOOLCHAIN_FILE=/opt/win32/CMakeToolchain.txt make -j4 && cd .. && rm -rf dependencies

COPY licenses /opt/licenses
COPY binaries/inno-setup /opt/inno-setup
RUN chmod -R go+r /opt && \
    find /opt -type d -exec chmod go+x {} \;
RUN update-ccache-symlinks
run usermod ubuntu -l mgba -d /home/mgba && groupmod -n mgba ubuntu
run mkdir -p /home/mgba/.ccache && chown -R mgba:mgba /home/mgba/
VOLUME /home/mgba/src /home/mgba/.ccache
USER mgba
WORKDIR /home/mgba/src
RUN git config --global --add safe.directory /home/mgba/src
ENV PATH=/usr/lib/ccache:$PATH
ENV BUILD_DIR=build-win32
CMD mkdir -p "$BUILD_DIR" && cd "$BUILD_DIR" && \
    cmake .. \
        -DEXTRA_LICENSES=$(ls /opt/licenses/* | tr $'\n' ';') \
        -DCMAKE_TOOLCHAIN_FILE=/opt/win32/CMakeToolchain.txt \
        -DBUILD_SHARED=OFF -DBUILD_STATIC=ON $CMAKE_FLAGS && \
    make install DESTDIR=install
