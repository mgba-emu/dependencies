FROM ubuntu:xenial

RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential cmake git \
        libavcodec-dev libavformat-dev libavresample-dev libavutil-dev \
        libedit-dev libelf-dev libmagickwand-dev libpng-dev \
        libqt5opengl5-dev libsdl2-dev libsqlite3-dev libswscale-dev \
        libzip-dev qtmultimedia5-dev && \
    apt-get autoremove -y && apt-get clean

RUN useradd mgba -m
VOLUME /home/mgba/src
USER mgba
WORKDIR /home/mgba/src
CMD mkdir -p build-xenial && cd build-xenial && cmake .. $CMAKE_FLAGS && make install DESTDIR=install
