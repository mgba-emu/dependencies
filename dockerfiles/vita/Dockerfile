FROM ubuntu:focal

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends bzip2 ca-certificates cmake \
        curl git make python wget xz-utils && \
    apt-get autoremove -y && apt-get clean

WORKDIR /root
ENV VITASDK=/opt/vitasdk
ENV PATH=$VITASDK/bin:$PATH

RUN git clone https://github.com/vitasdk/vdpm
RUN mkdir -p $VITASDK && . vdpm/include/install-vitasdk.sh && \
    install_vitasdk $VITASDK && rm -rf vdpm
RUN vdpm zlib && vdpm libpng && vdpm libvita2d
RUN apt-get autoremove -y python && apt-get clean

RUN useradd mgba -m
VOLUME /home/mgba/src
USER mgba
RUN git config --global --add safe.directory /home/mgba/src
WORKDIR /home/mgba/src
ENV BUILD_DIR=build-vita
CMD mkdir -p "$BUILD_DIR" && cd "$BUILD_DIR" && cmake .. -DCMAKE_TOOLCHAIN_FILE=../src/platform/psp2/CMakeToolchain.vitasdk $CMAKE_FLAGS && make install DESTDIR=install
