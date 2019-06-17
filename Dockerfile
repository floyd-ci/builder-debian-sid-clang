FROM debian:sid-slim

RUN apt-get -qq update && apt-get -qq install -y --no-install-recommends \
        ca-certificates \
        cmake \
        ninja-build \
    && rm -rf /var/lib/apt/lists/*

ARG LLVM_VERSION=7
ARG EXPERIMENTAL

RUN if [ $EXPERIMENTAL ]; then \
        echo 'deb http://ftp.debian.org/debian experimental main' >> /etc/apt/sources.list; \
    fi \
    && apt-get -qq update \
    && apt-get -qq install ${EXPERIMENTAL:+-t experimental} -y --no-install-recommends \
        clang-${LLVM_VERSION} \
        clang-tidy-${LLVM_VERSION} \
    && rm -rf /var/lib/apt/lists/*

ENV CC="/usr/lib/llvm-${LLVM_VERSION}/bin/clang" \
    CXX="/usr/lib/llvm-${LLVM_VERSION}/bin/clang++" \
    PATH=/usr/lib/llvm-${LLVM_VERSION}/bin:$PATH
