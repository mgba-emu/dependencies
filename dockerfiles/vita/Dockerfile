FROM ubuntu:focal

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends bzip2 ca-certificates cmake \
        curl git make python3 wget xz-utils && \
    apt-get autoremove -y && apt-get clean

WORKDIR /root
ENV VITASDK=/opt/vitasdk
ENV PATH=$VITASDK/bin:$PATH

RUN git clone https://github.com/vitasdk/vdpm
RUN mkdir -p $VITASDK && . vdpm/include/install-vitasdk.sh && \
    get_download_link () { echo 'https://github.com/vitasdk/autobuilds/releases/download/master-linux-v2.493/vitasdk-x86_64-linux-gnu-2023-06-16_14-02-53.tar.bz2'; } && \
    install_vitasdk $VITASDK && rm -rf vdpm
RUN vdpm zlib && vdpm libpng && vdpm libvita2d
RUN apt-get autoremove -y python && apt-get clean

RUN useradd mgba -m
VOLUME /home/mgba/src
USER mgba
WORKDIR /home/mgba/src
RUN git config --global --add safe.directory /home/mgba/src
ENV BUILD_DIR=build-vita
CMD mkdir -p "$BUILD_DIR" && cd "$BUILD_DIR" && cmake .. -DCMAKE_TOOLCHAIN_FILE=../src/platform/psp2/CMakeToolchain.vitasdk $CMAKE_FLAGS && make install DESTDIR=install
