FROM emscripten/emsdk

RUN apt-get update && \
    apt-get install -y --no-install-recommends make cmake git && \
    apt-get autoremove -y && apt-get clean

RUN userdel emscripten -r && useradd mgba -m
VOLUME /home/mgba/src
USER mgba
WORKDIR /home/mgba/src
RUN git config --global --add safe.directory /home/mgba/src
ENV BUILD_DIR=build-wasm
CMD mkdir -p "$BUILD_DIR" && cd "$BUILD_DIR" && emcmake cmake .. $CMAKE_FLAGS && make install DESTDIR=install
