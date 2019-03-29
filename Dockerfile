FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    automake \
    build-essential \
    git \
    libtool \
    make \
    npm \
    wget \
    unzip \
    libprotoc-dev \
    golang

## Install protoc

ENV PROTOBUF_VERSION 3.6.1

RUN wget https://github.com/protocolbuffers/protobuf/releases/download/v$PROTOBUF_VERSION/protoc-$PROTOBUF_VERSION-linux-x86_64.zip && \
    unzip protoc-$PROTOBUF_VERSION-linux-x86_64.zip -d /usr/local/ && \
    rm -rf protoc-$PROTOBUF_VERSION-linux-x86_64.zip

## Install protoc-gen-go

ENV PROTOC_GEN_GO_VERSION v1.3.0

RUN git clone https://github.com/golang/protobuf /root/go/src/github.com/golang/protobuf && \
    cd /root/go/src/github.com/golang/protobuf && \
    git fetch --all --tags --prune && \
    git checkout tags/$PROTOC_GEN_GO_VERSION && \
    go install ./protoc-gen-go && \
    ln -s /root/go/bin/protoc-gen-go /usr/local/bin/protoc-gen-go && \
    rm -rf /root/go/src

## Install protoc-gen-grpc-web

ENV PROTOC_GEN_GRPC_WEB_VERSION 1.0.4

RUN git clone https://github.com/grpc/grpc-web /github/grpc-web && \
    cd /github/grpc-web && \
    git fetch --all --tags --prune && \
    git checkout tags/$PROTOC_GEN_GRPC_WEB_VERSION && \
    make install-plugin && \
    rm -rf /github

## Install protoc-gen-ts

ENV PROTOC_GEN_TS_VERSION 0.9.0
ENV GOOGLE_PROTOBUF_VERSION 3.6.1

RUN npm install ts-protoc-gen@$PROTOC_GEN_TS_VERSION google-protobuf@$GOOGLE_PROTOBUF_VERSION && \
    ln -s /node_modules/.bin/protoc-gen-ts /usr/local/bin/protoc-gen-ts
