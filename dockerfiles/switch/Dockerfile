FROM devkitpro/devkita64

RUN apt-get update && \
    apt-get install -y --no-install-recommends cmake git make && \
    apt-get autoremove -y && apt-get clean

WORKDIR /root

RUN useradd mgba -m
VOLUME /home/mgba/src
USER mgba
WORKDIR /home/mgba/src
ENV BUILD_DIR=build-switch
ENV PATH=${DEVKITPRO}/tools/bin:$PATH
CMD mkdir -p "$BUILD_DIR" && cd "$BUILD_DIR" && cmake .. -DCMAKE_TOOLCHAIN_FILE=../src/platform/switch/CMakeToolchain.txt $CMAKE_FLAGS && make install DESTDIR=install
