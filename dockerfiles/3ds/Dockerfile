FROM ubuntu:bionic

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates \
        cmake curl gcc g++ git gnupg libc6-dev make xz-utils zip && \
    apt-get autoremove -y && apt-get clean

WORKDIR /root

ENV DEVKITPRO=/opt/devkitpro
ENV DEVKITARM=$DEVKITPRO/devkitARM

RUN curl -LO https://github.com/devkitPro/pacman/releases/download/devkitpro-pacman-1.0.1/devkitpro-pacman.deb && \
    dpkg -i devkitpro-pacman.deb && \
    rm devkitpro-pacman.deb

RUN dkp-pacman -Syu --noconfirm general-tools 3dstools picasso libctru citro3d 3ds-zlib 3ds-libpng devkitARM && \
    dkp-pacman -Scc --noconfirm

RUN git clone --recursive https://github.com/Steveice10/bannertool.git -b 1.0.0 && \
    (cd bannertool && make && install output/*/bannertool $DEVKITPRO/tools/bin) && rm -rf bannertool

RUN git clone https://github.com/profi200/Project_CTR.git && \
    (cd Project_CTR/makerom && make && install makerom $DEVKITPRO/tools/bin) && rm -rf Project_CTR

RUN apt-get autoremove -y curl gcc g++ gnupg libc6-dev zip

RUN useradd mgba -m
VOLUME /home/mgba/src
USER mgba
WORKDIR /home/mgba/src
ENV BUILD_DIR=build-3ds
ENV PATH=${DEVKITPRO}/tools/bin:$PATH
CMD mkdir -p "$BUILD_DIR" && cd "$BUILD_DIR" && cmake .. -DCMAKE_TOOLCHAIN_FILE=../src/platform/3ds/CMakeToolchain.txt $CMAKE_FLAGS && make install DESTDIR=install
