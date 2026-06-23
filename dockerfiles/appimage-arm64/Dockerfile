FROM ubuntu:jammy

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends autoconf automake \
        build-essential ca-certificates curl gnupg libffi-dev libwayland-dev \
        ccache cmake file git libasound2-dev libatspi2.0-dev libcmocka-dev \
        libdecor-0-dev libdrm-dev libedit-dev libegl1-mesa-dev libelf-dev \
        libfontconfig-dev libgl1-mesa-dev libglu1-mesa-dev libhidapi-dev \
        libinput-dev libpulse-dev libtool libpipewire-0.3-dev libx11-dev \
        libx11-xcb-dev '^libxcb.*-dev' libxcursor-dev libxext-dev \
        libxfixes-dev libxi-dev libxkbcommon-dev libxkbcommon-x11-dev \
        libxrandr-dev libxss-dev libxtst-dev nasm pkg-config && \
    apt-get autoremove -y && apt-get clean


RUN mkdir -p /usr/local/bin /opt
RUN LINUXDEPLOY_URL=https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-aarch64.AppImage && \
    RUNTIME_URL=https://github.com/AppImage/type2-runtime/releases/download/continuous/runtime-aarch64 && \
    curl -L "${LINUXDEPLOY_URL}" -o /opt/linuxdeploy-aarch64.AppImage && \
    curl -L "${RUNTIME_URL}" -o /opt/appimage-runtime
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
    OUTPUT=build.appimage LDAI_RUNTIME_FILE=/opt/appimage-runtime linuxdeploy -o appimage -v2 --appdir=AppDir --exclude-library=libwayland-client.so*
