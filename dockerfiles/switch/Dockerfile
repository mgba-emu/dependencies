FROM ubuntu:bionic

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates cmake curl git gnupg make xz-utils && \
    apt-get autoremove -y && apt-get clean

WORKDIR /root

ENV DEVKITPRO=/opt/devkitpro
ENV DEVKITA64=$DEVKITPRO/devkitA64

RUN curl -LO https://github.com/devkitPro/pacman/releases/download/devkitpro-pacman-1.0.1/devkitpro-pacman.deb && \
    dpkg -i devkitpro-pacman.deb && \
    rm devkitpro-pacman.deb

RUN dkp-pacman -Syu --noconfirm devkitA64 general-tools switch-tools switch-mesa switch-zlib switch-libpng libnx && \
    dkp-pacman -Scc --noconfirm

RUN [ ! \( "$(dkp-pacman -Q libnx | cut -d' ' -f2)" ">" "1.4.0-1" \) ] && \
    git clone https://github.com/switchbrew/libnx.git && \
    (cd libnx && make -j2 install) && rm -rf libnx

RUN [ ! \( "$(dkp-pacman -Q switch-libdrm_nouveau | cut -d' ' -f2)" ">" "0.1.0-1" \) ] && \
    git clone https://github.com/devkitPro/libdrm_nouveau.git && \
    (cd libdrm_nouveau && make -j2 install) && rm -rf libdrm_nouveau

RUN apt-get autoremove -y curl gnupg

RUN useradd mgba -m
VOLUME /home/mgba/src
USER mgba
WORKDIR /home/mgba/src
ENV BUILD_DIR=build-switch
ENV PATH=${DEVKITPRO}/tools/bin:$PATH
CMD mkdir -p "$BUILD_DIR" && cd "$BUILD_DIR" && cmake .. -DCMAKE_TOOLCHAIN_FILE=../src/platform/switch/CMakeToolchain.txt $CMAKE_FLAGS && make install DESTDIR=install
