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

RUN wget https://github.com/google/protobuf/releases/download/v$PROTOBUF_VERSION/protoc-$PROTOBUF_VERSION-linux-x86_64.zip && \
    unzip protoc-$PROTOBUF_VERSION-linux-x86_64.zip -d /usr/local/ && \
    rm -rf protoc-$PROTOBUF_VERSION-linux-x86_64.zip

## Install protoc-gen-go

RUN go get -u github.com/golang/protobuf/protoc-gen-go && \
    ln -s /root/go/bin/protoc-gen-go /usr/local/bin/protoc-gen-go

## Install protoc-gen-grpc-web

RUN git clone https://github.com/grpc/grpc-web /github/grpc-web && \
    cd /github/grpc-web && \
    make install-plugin && \
    rm -rf /github

## Install protoc-gen-ts

RUN npm install ts-protoc-gen && \
    ln -s /node_modules/.bin/protoc-gen-ts /usr/local/bin/protoc-gen-ts
