FROM ubuntu:artful

RUN apt-get update && \
    apt-get install -y --no-install-recommends autoconf automake \
        ca-certificates cmake g++ g++-mingw-w64-x86-64 git libtool make \
        pkg-config python wine-development yasm && \
    apt-get autoremove -y && apt-get clean

COPY . /root/dependencies
WORKDIR /root/dependencies

RUN git clean -dfx && \
    git submodule update --init && \
    git submodule foreach --recursive git submodule init && \
    ./buildscripts/clean-extra.sh && \
	git submodule foreach git clean -dfx && \
    git submodule update --recursive

RUN ROOT=/opt/win64 HOST=x86_64-w64-mingw32 make -j2 && cd .. && rm -rf dependencies

COPY dockerfiles/windows-w64/CMakeToolchain.txt /opt/win64
RUN useradd mgba -m
VOLUME /home/mgba/src
USER mgba
WORKDIR /home/mgba/src
CMD mkdir -p build-win64 && cd build-win64 && \
    cmake .. -DCMAKE_TOOLCHAIN_FILE=/opt/win64/CMakeToolchain.txt -DBUILD_SHARED=OFF -DBUILD_STATIC=ON && \
    make install DESTDIR=install
