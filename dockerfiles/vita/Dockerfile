FROM ubuntu:xenial

RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential bzip2 \
        ca-certificates cmake curl git m4 texinfo wget xz-utils && \
    apt-get autoremove -y && apt-get clean

WORKDIR /root
ENV VITASDK=/opt/vitasdk
ENV PATH=$VITASDK/bin:$PATH

RUN git clone https://github.com/vitasdk/buildscripts
RUN cd buildscripts && mkdir build && cd build && \
    cmake .. && make && mv vitasdk $VITASDK && \
    cd .. && rm -rf build
RUN vdpm zlib && vdpm libzip && vdpm libpng && vdpm libvita2d

RUN useradd mgba -m
VOLUME /home/mgba/src
USER mgba
WORKDIR /home/mgba/src
CMD mkdir -p build-vita && cd build-vita && cmake .. -DCMAKE_TOOLCHAIN_FILE=../src/platform/psp2/CMakeToolchain.vitasdk -DCMAKE_INSTALL_PREFIX=// && make install DESTDIR=install
