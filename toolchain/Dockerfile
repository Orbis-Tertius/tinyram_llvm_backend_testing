FROM ubuntu:21.10

WORKDIR /root

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install -y \
    wget unzip curl \
    build-essential cmake git pkg-config \
    python3 \
    clang \
    lld \
    ninja-build

COPY build.sh .
RUN ./build.sh

ENV PATH="/toolchain/bin:${PATH}"
ENV LD_LIBRARY_PATH="/toolchain/lib:${LD_LIBRARY_PATH}"

