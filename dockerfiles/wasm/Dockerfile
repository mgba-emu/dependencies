FROM trzeci/emscripten-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends make cmake git && \
    apt-get autoremove -y && apt-get clean

RUN userdel emscripten -r && useradd mgba -m
RUN bash -c 'emcc -s USE_SDL=2 -s FULL_ES2 -x c <(echo "include <SDL2/SDL.h>") && rm a.out*'
VOLUME /home/mgba/src
USER mgba
WORKDIR /home/mgba/src
ENV BUILD_DIR=build-wasm
CMD mkdir -p "$BUILD_DIR" && cd "$BUILD_DIR" && emconfigure cmake .. $CMAKE_FLAGS && make install DESTDIR=install
