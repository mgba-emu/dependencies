FROM ubuntu:xenial

RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential ccache cmake \
        git libavcodec-dev libavfilter-dev libavformat-dev libavresample-dev \
        libavutil-dev libcmocka-dev libedit-dev libelf-dev libpng-dev \
        libqt5opengl5-dev libsdl2-dev libsqlite3-dev libswscale-dev \
        libzip-dev qtmultimedia5-dev qttools5-dev-tools && \
    apt-get autoremove -y && apt-get clean

RUN update-ccache-symlinks
RUN useradd mgba -m
RUN mkdir -p /home/mgba/.ccache && chown mgba:mgba /home/mgba/.ccache
VOLUME /home/mgba/src /home/mgba/.ccache
USER mgba
WORKDIR /home/mgba/src
ENV PATH=/usr/lib/ccache:$PATH
ENV BUILD_DIR=build-xenial
CMD mkdir -p "$BUILD_DIR" && cd "$BUILD_DIR" && cmake .. -DCMAKE_AR=/usr/bin/gcc-ar -DCMAKE_RANLIB=/usr/bin/gcc-ranlib $CMAKE_FLAGS && make install DESTDIR=install
