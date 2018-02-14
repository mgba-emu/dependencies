FROM mgba/windows:base

WORKDIR /root/dependencies

RUN ROOT=/opt/win64 HOST=x86_64-w64-mingw32 make -j2 && \
    git clean -dfx && git submodule foreach --recursive git clean -dfx

COPY CMakeToolchain.txt /opt/win64
RUN useradd mgba -m
VOLUME /home/mgba/src
USER mgba
WORKDIR /home/mgba/src
CMD mkdir -p build-win64 && cd build-win64 && \
    cmake .. -DCMAKE_TOOLCHAIN_FILE=/opt/win64/CMakeToolchain.txt -DBUILD_SHARED=OFF -DBUILD_STATIC=ON && \
    make install DESTDIR=install
