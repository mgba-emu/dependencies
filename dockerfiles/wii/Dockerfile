FROM devkitpro/devkitppc

RUN apt-get update && \
    apt-get install -y --no-install-recommends unzip && \
    apt-get autoremove -y && apt-get clean

WORKDIR /root
RUN curl -L https://github.com/FIX94/libwiidrc/releases/download/v1.3/libwiidrc-v1.3.zip -o libwiidrc.zip
RUN unzip libwiidrc.zip "Library/*" && mv Library/lib/libwiidrc.a ${DEVKITPRO}/portlibs/ppc/lib && mv Library/include/wiidrc ${DEVKITPRO}/portlibs/ppc/include && rm -r Library libwiidrc.zip

RUN useradd mgba -m
VOLUME /home/mgba/src
USER mgba
RUN git config --global --add safe.directory /home/mgba/src
WORKDIR /home/mgba/src
ENV BUILD_DIR=build-wii
CMD mkdir -p "$BUILD_DIR" && cd "$BUILD_DIR" && cmake .. -DCMAKE_TOOLCHAIN_FILE=../src/platform/wii/CMakeToolchain.txt $CMAKE_FLAGS && make install DESTDIR=install
