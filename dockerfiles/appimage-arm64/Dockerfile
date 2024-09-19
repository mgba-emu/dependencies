FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates curl gnupg && \
    echo 'deb-src http://archive.ubuntu.com/ubuntu/ jammy main' >> /etc/apt/sources.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 871920D1991BC93C && \
    apt-get update
RUN apt-get build-dep -y --no-install-recommends libffi8/jammy && \
    apt-get source --compile libffi8/jammy && \
    apt-get install -y --no-install-recommends ./libffi8_*.deb && \
    rm libffi8_*.deb
RUN apt-get build-dep -y --no-install-recommends wayland/jammy && \
    apt-get source --compile wayland/jammy && \
    apt-get install -y --no-install-recommends ./libwayland*.deb && \
    rm libwayland*.deb
RUN curl -LO https://ftp.debian.org/debian/pool/main/a/autoconf/autoconf_2.71-3_all.deb && \
    apt-get install -y --no-install-recommends ./autoconf*.deb && \
    rm autoconf*.deb
RUN apt-get install -y --no-install-recommends automake build-essential \
        ccache cmake file git libasound2-dev libatspi2.0-dev libcmocka-dev \
        libdrm-dev libedit-dev libegl1-mesa-dev libelf-dev libfontconfig-dev \
        libgl1-mesa-dev libglu1-mesa-dev libinput-dev libpulse-dev libtool \
        libx11-dev libx11-xcb-dev '^libxcb.*-dev' libxext-dev libxi-dev \
        libxkbcommon-dev libxkbcommon-x11-dev libxrender-dev nasm \
        pkg-config && \
    apt-get autoremove -y && apt-get clean


RUN mkdir -p /usr/local/bin /opt
RUN LINUXDEPLOY_URL=https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-aarch64.AppImage && \
    curl -L "${LINUXDEPLOY_URL}" -o /opt/linuxdeploy-aarch64.AppImage
RUN chmod +x /opt/linuxdeploy*.AppImage
RUN cd /opt && ./linuxdeploy-aarch64.AppImage --appimage-extract

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
RUN git config --global --add safe.directory /home/mgba/src
ENV PATH=/usr/lib/ccache:$PATH:/usr/local/bin:/opt/squashfs-root/usr/bin
ENV BUILD_DIR=build-appimage-arm64
CMD mkdir -p "$BUILD_DIR" && cd "$BUILD_DIR" && \
    cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DBUILD_SHARED=OFF -DBUILD_STATIC=ON -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DBUILD_GL=OFF $CMAKE_FLAGS && \
    BINARY_NAME=$(cmake -DPRINT_STRING=BINARY_NAME -P ../version.cmake) && \
    cmake . -DDATADIR="../share/${BINARY_NAME}" $CMAKE_FLAGS && \
    make && \
    cmake --install . --prefix AppDir/usr --component $BINARY_NAME && \
    cmake --install . --prefix AppDir/usr --component $BINARY_NAME-qt && \
    OUTPUT=build.appimage linuxdeploy -o appimage -v2 --appdir=AppDir
