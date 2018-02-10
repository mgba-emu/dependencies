FROM mgba/windows:base

WORKDIR /root/dependencies

RUN ROOT=/root/win64 HOST=x86_64-w64-mingw32 make && \
    git clean -dfx && git submodule foreach --recursive git clean -dfx

WORKDIR /root
