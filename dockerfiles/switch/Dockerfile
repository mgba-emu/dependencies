FROM ubuntu:xenial

RUN apt-get update && \
    apt-get install -y --no-install-recommends bzip2 ca-certificates cmake \
        curl git make p7zip && \
    apt-get autoremove -y && apt-get clean

WORKDIR /root
RUN curl -L \
    -O https://downloads.sourceforge.net/project/devkitpro/devkitA64/alpha6/devkitA64_a6-x86_64-linux.7z
RUN mkdir -p /opt/devkitPro/libnx && \
    7zr x devkitA64*.7z -o/opt/devkitPro

ENV DEVKITPRO=/opt/devkitPro
ENV DEVKITA64=/opt/devkitPro/devkitA64

RUN git clone https://github.com/switchbrew/libnx.git && cd libnx && make install

RUN useradd mgba -m
VOLUME /home/mgba/src
USER mgba
WORKDIR /home/mgba/src
CMD mkdir -p build-switch && cd build-switch && cmake .. -DCMAKE_TOOLCHAIN_FILE=../src/platform/switch/CMakeToolchain.txt -DCMAKE_INSTALL_PREFIX=// $CMAKE_FLAGS && make install DESTDIR=install
