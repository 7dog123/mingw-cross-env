FROM debian:trixie-slim

ARG DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -ys autoconf automake bash bison bzip2 \
                    cmake flex g++ intltool make sed \
                    libtool libltdl-dev openssl libssl-dev \
                    libxml-parser-perl patch perl \
                    pkg-config scons unzip wget \
                    xz-utils yasm

RUN make