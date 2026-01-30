FROM devkitpro/devkitppc

RUN apt-get update && \
    apt-get install -y --no-install-recommends unzip && \
    apt-get autoremove -y && apt-get clean

WORKDIR /root
RUN git clone https://github.com/FIX94/libwiidrc.git && \
	(cd libwiidrc && mkdir lib && make && mv lib/libwiidrc.a ${DEVKITPRO}/portlibs/ppc/lib && mv include/wiidrc ${DEVKITPRO}/portlibs/ppc/include) && \
	rm -rf libwiidrc

RUN useradd mgba -m
VOLUME /home/mgba/src
USER mgba
WORKDIR /home/mgba/src
RUN git config --global --add safe.directory /home/mgba/src
ENV BUILD_DIR=build-wii
CMD mkdir -p "$BUILD_DIR" && cd "$BUILD_DIR" && cmake .. -DCMAKE_TOOLCHAIN_FILE=../src/platform/wii/CMakeToolchain.txt $CMAKE_FLAGS && make install DESTDIR=install
