FROM mgba/windows:base

WORKDIR /root/dependencies

RUN ROOT=/root/win32 HOST=i686-w64-mingw32 make && \
    git clean -dfx && git submodule foreach --recursive git clean -dfx

WORKDIR /root
