FROM ubuntu:artful

RUN apt-get update && \
    apt-get install -y --no-install-recommends autoconf automake \
        ca-certificates cmake g++ git libtool make mingw-w64 pkg-config \
        python wine-development yasm && \
    apt-get autoremove -y && apt-get clean

WORKDIR /root
RUN git clone https://github.com/mgba-emu/dependencies.git
RUN cd dependencies && \
    git submodule update --init && \
    git submodule foreach --recursive git submodule init && \
    ./buildscripts/clean-extra.sh && \
    git submodule update --recursive
