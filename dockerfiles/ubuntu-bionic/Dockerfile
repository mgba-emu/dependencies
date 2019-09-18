FROM ubuntu:bionic

RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential cmake git \
        libavcodec-dev libavfilter-dev libavformat-dev libavresample-dev \
        libavutil-dev libedit-dev libelf-dev libmagickwand-dev libpng-dev \
        libqt5opengl5-dev libsdl2-dev libsqlite3-dev libswscale-dev \
        libzip-dev qtmultimedia5-dev qttools5-dev-tools && \
    apt-get autoremove -y && apt-get clean

RUN useradd mgba -m
VOLUME /home/mgba/src
USER mgba
WORKDIR /home/mgba/src
ENV BUILD_DIR=build-bionic
CMD mkdir -p "$BUILD_DIR" && cd "$BUILD_DIR" && cmake .. $CMAKE_FLAGS && make install DESTDIR=install
