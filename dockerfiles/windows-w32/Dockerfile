FROM mgba/windows:base

WORKDIR /root/dependencies

RUN ROOT=/opt/win32 HOST=i686-w64-mingw32 make -j2 && \
    git clean -dfx && git submodule foreach --recursive git clean -dfx

COPY CMakeToolchain.txt /opt/win32
RUN useradd mgba -m
VOLUME /home/mgba/src
USER mgba
WORKDIR /home/mgba/src
CMD mkdir -p build-win32 && cd build-win32 && \
    cmake .. -DCMAKE_TOOLCHAIN_FILE=/opt/win32/CMakeToolchain.txt -DBUILD_SHARED=OFF -DBUILD_STATIC=ON && \
    make install DESTDIR=install
