FROM devkitpro/devkitarm

RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc g++ libc6-dev zip && \
    apt-get autoremove -y && apt-get clean

WORKDIR /root

RUN git clone https://github.com/Steveice10/bannertool.git -b 1.0.0 && \
    git -C bannertool submodule init && \
    git -C bannertool/buildtools config --local --replace-all submodule.buildtools.url https://github.com/Steveice10/buildtools && \
    git -C bannertool submodule update && \
    (cd bannertool && make && install output/*/bannertool $DEVKITPRO/tools/bin) && rm -rf bannertool

RUN git clone https://github.com/profi200/Project_CTR.git && \
    (cd Project_CTR/makerom && make && install makerom $DEVKITPRO/tools/bin) && rm -rf Project_CTR

RUN apt-get autoremove -y gcc g++ libc6-dev zip

RUN useradd mgba -m
VOLUME /home/mgba/src
USER mgba
RUN git config --global --add safe.directory /home/mgba/src
WORKDIR /home/mgba/src
ENV BUILD_DIR=build-3ds
CMD mkdir -p "$BUILD_DIR" && cd "$BUILD_DIR" && cmake .. -DCMAKE_TOOLCHAIN_FILE=../src/platform/3ds/CMakeToolchain.txt $CMAKE_FLAGS && make install DESTDIR=install
