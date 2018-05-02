FROM ubuntu:artful

RUN apt-get update && \
    apt-get install -y --no-install-recommends autoconf automake \
        ca-certificates cmake g++ g++-mingw-w64-i686 git libtool make \
        nasm pkg-config python wine-development yasm && \
    apt-get autoremove -y && apt-get clean

COPY . /root/dependencies
WORKDIR /root/dependencies

RUN git clean -dfx && \
    git submodule update --init && \
    git submodule foreach --recursive git submodule init && \
    ./buildscripts/clean-extra.sh && \
	git submodule foreach git clean -dfx && \
    git submodule update --recursive

RUN ROOT=/opt/win32 HOST=i686-w64-mingw32 make -j2 && cd .. && rm -rf dependencies

COPY dockerfiles/windows-w32/CMakeToolchain.txt /opt/win32
RUN chmod 644 /opt/win32/CMakeToolchain.txt && \
    useradd mgba -m
COPY licenses /home/mgba/licenses
VOLUME /home/mgba/src
USER mgba
WORKDIR /home/mgba/src
ENV BUILD_DIR=build-win32
CMD mkdir -p "$BUILD_DIR" && cd "$BUILD_DIR" && \
    cmake .. -DCMAKE_TOOLCHAIN_FILE=/opt/win32/CMakeToolchain.txt -DBUILD_SHARED=OFF -DBUILD_STATIC=ON $CMAKE_FLAGS && \
    make install DESTDIR=install
