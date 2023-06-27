
# this is an updated version of jfbrandhorst/grpc-web-generators : https://github.com/johanbrandhorst/grpc-web-generators
# it is a multistage build, reducing to 1/5 (!)
# node:18.16.1-bullseye-slim as base image
# ts-protoc-gen has been replaced by grpc-protoc-gen
# bullesye / bullseye-slim are using python3.9

# to update the protoc etc. versions, change the PROTOBUF_VERSION and PROTOC_X variables

# Build stage

FROM node:18.16.1-bullseye as build

ENV DEBIAN_FRONTEND noninteractive \
    LANG=C.UTF-8 \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PROTOBUF_VERSION=23.3 \
    PROTOC_GEN_GO_VERSION=v1.5.3 \
    PROTOC_GEN_GRPC_VERSION=2.0.4 \
    PROTOC_GEN_TS_VERSION=0.15.0 \
    PROTOC_GEN_GRPC_WEB_VERSION=1.4.2 


ARG APP_ROOT=/usr/app

ENV APP_ROOT=${APP_ROOT}

WORKDIR ${APP_ROOT}

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
    python3-pip \
    golang

## Install protoc

RUN wget https://github.com/protocolbuffers/protobuf/releases/download/v$PROTOBUF_VERSION/protoc-$PROTOBUF_VERSION-linux-x86_64.zip && \
    unzip protoc-$PROTOBUF_VERSION-linux-x86_64.zip -d /usr/local/ && \
    rm -rf protoc-$PROTOBUF_VERSION-linux-x86_64.zip

## Install protoc-gen-go
## https://docs.docker.com/language/golang/build-images/

RUN git clone https://github.com/golang/protobuf $APP_ROOT/go/src/github.com/golang/protobuf && \
    cd $APP_ROOT/go/src/github.com/golang/protobuf && \
    git fetch --all --tags --prune && \
    git checkout tags/$PROTOC_GEN_GO_VERSION && \
    go install ./protoc-gen-go && \
    rm -rf $APP_ROOT/go/src
    #cp $APP_ROOT/go/bin/protoc-gen-go /usr/local/bin/protoc-gen-go && \

## Install protoc-gen-grpc-web

RUN git clone https://github.com/grpc/grpc-web /github/grpc-web && \
    cd /github/grpc-web && \
    git fetch --all --tags --prune && \
    git checkout tags/$PROTOC_GEN_GRPC_WEB_VERSION && \
    make install-plugin && \
    rm -rf /github

## Install protoc-gen (npm)

#google-protobuf@$PROTOBUF_VERSION

RUN npm install protoc-gen-grpc@$PROTOC_GEN_GRPC_VERSION  && \
    cp ./node_modules/.bin/protoc-gen-grpc /usr/local/bin/protoc-gen-grpc
    

## Install protoc-gen-ts

# google-protobuf@$PROTOBUF_VERSION

RUN npm install ts-protoc-gen@$PROTOC_GEN_TS_VERSION  && \
    cp ./node_modules/.bin/protoc-gen-ts /usr/local/bin/protoc-gen-ts
    
## Install protoc plugin for python

RUN pip3 install grpcio-tools

# deployment stage: using previous build to reduce image size

FROM node:18.16.1-bullseye-slim

ENV DEBIAN_FRONTEND noninteractive \
    LANG=C.UTF-8 \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

ARG APP_ROOT=/usr/app
ENV APP_ROOT=${APP_ROOT}

WORKDIR ${APP_ROOT}

# copy all built files to new image

# protoc etc.
COPY --from=build /usr/local/bin /usr/local/bin
# for google/protobuf
COPY --from=build /usr/local/include /usr/local/include 

COPY --from=build $APP_ROOT/package.json $APP_ROOT/package.json

RUN npm install --production

# copy python files

COPY  --from=build /usr/local/lib/python3.9/dist-packages /usr/local/lib/python3.9/dist-packages


