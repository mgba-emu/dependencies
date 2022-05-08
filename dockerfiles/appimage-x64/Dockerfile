FROM debian:buster

ENV DEBIAN_FRONTEND=noninteractive

RUN echo 'deb http://deb.debian.org/debian buster-backports main' >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends autoconf automake \
        build-essential ca-certificates ccache cmake/buster-backports curl \
        file git libasound2-dev libatspi2.0-dev libcmocka-dev libedit-dev \
        libegl1-mesa-dev libfontconfig-dev libgl1-mesa-dev libglu1-mesa-dev \
        libinput-dev libpulse-dev libtool libx11-dev libx11-xcb-dev \
        '^libxcb.*-dev'  libxext-dev libxi-dev  libxkbcommon-dev \
        libxkbcommon-x11-dev libxrender-dev nasm pkg-config && \
    apt-get autoremove -y && apt-get clean

RUN mkdir -p /usr/local/bin /opt
RUN LINUXDEPLOY_URL=https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage && \
    curl -L "${LINUXDEPLOY_URL}" -o /opt/linuxdeploy-x86_64.AppImage
RUN chmod +x /opt/linuxdeploy*.AppImage
RUN cd /opt && ./linuxdeploy-x86_64.AppImage --appimage-extract

COPY libraries /root/dependencies/
WORKDIR /root/dependencies
RUN find x265 -name .git -delete

RUN ROOT=/usr/local make -j4 && cd .. && rm -rf dependencies
COPY licenses /opt/licenses
RUN chmod -R go+r /usr/local && \
    find /usr/local -type d -exec chmod go+x {} \;
RUN update-ccache-symlinks
RUN useradd mgba -m
RUN mkdir -p /home/mgba/.ccache && chown mgba:mgba /home/mgba/.ccache
VOLUME /home/mgba/src /home/mgba/.ccache
USER mgba
WORKDIR /home/mgba/src
ENV PATH=/usr/lib/ccache:$PATH:/usr/local/bin:/opt/squashfs-root/usr/bin
ENV BUILD_DIR=build-appimage
CMD mkdir -p "$BUILD_DIR" && cd "$BUILD_DIR" && \
    cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DBUILD_SHARED=OFF -DBUILD_STATIC=ON -DCMAKE_POSITION_INDEPENDENT_CODE=ON $CMAKE_FLAGS && \
    BINARY_NAME=$(cmake -DPRINT_STRING=BINARY_NAME -P ../version.cmake) && \
    cmake . -DDATADIR="../share/${BINARY_NAME}" $CMAKE_FLAGS && \
    make && \
    cmake --install . --prefix AppDir/usr --component $BINARY_NAME && \
    cmake --install . --prefix AppDir/usr --component $BINARY_NAME-qt && \
    OUTPUT=build.appimage linuxdeploy -o appimage -v2 --appdir=AppDir
