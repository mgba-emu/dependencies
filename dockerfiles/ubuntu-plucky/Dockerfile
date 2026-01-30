FROM ubuntu:plucky

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential ccache cmake \
        git libavcodec-dev libavfilter-dev libavformat-dev libavutil-dev \
        libcmocka-dev libedit-dev libelf-dev libjson-c-dev liblua5.4-dev \
        libpng-dev libsdl3-dev libsqlite3-dev libswresample-dev \
        libswscale-dev libzip-dev qt6-multimedia-dev qt6-tools-dev zipcmp \
        zipmerge ziptool && \
    apt-get autoremove -y && apt-get clean

RUN update-ccache-symlinks
RUN usermod ubuntu -l mgba -d /home/mgba && groupmod -n mgba ubuntu
RUN mkdir -p /home/mgba/.ccache && chown -R mgba:mgba /home/mgba/
VOLUME /home/mgba/src /home/mgba/.ccache
USER mgba
WORKDIR /home/mgba/src
RUN git config --global --add safe.directory /home/mgba/src
ENV PATH=/usr/lib/ccache:$PATH
ENV BUILD_DIR=build-oracular
CMD mkdir -p "$BUILD_DIR" && cd "$BUILD_DIR" && cmake .. $CMAKE_FLAGS && make install DESTDIR=install
