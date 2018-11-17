FROM ubuntu:bionic

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates cmake curl git gnupg make xz-utils && \
    apt-get autoremove -y && apt-get clean

WORKDIR /root

ENV DEVKITPRO=/opt/devkitpro
ENV DEVKITPPC=$DEVKITPRO/devkitPPC

RUN curl -LO https://github.com/devkitPro/pacman/releases/download/devkitpro-pacman-1.0.1/devkitpro-pacman.deb && \
    dpkg -i devkitpro-pacman.deb && \
    rm devkitpro-pacman.deb

RUN dkp-pacman -Syu --noconfirm general-tools gamecube-tools libogc libfat-ogc ppc-zlib ppc-libpng devkitPPC && \
    dkp-pacman -Scc --noconfirm

RUN apt-get autoremove -y curl gnupg

RUN useradd mgba -m
VOLUME /home/mgba/src
USER mgba
WORKDIR /home/mgba/src
ENV BUILD_DIR=build-wii
ENV PATH=${DEVKITPRO}/tools/bin:$PATH
CMD mkdir -p "$BUILD_DIR" && cd "$BUILD_DIR" && cmake .. -DCMAKE_TOOLCHAIN_FILE=../src/platform/wii/CMakeToolchain.txt $CMAKE_FLAGS && make install DESTDIR=install
