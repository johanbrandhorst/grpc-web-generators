# grpc-web-generators

Dockerfile for generating grpc-web protofiles.

This is an updated version of [https://github.com/johanbrandhorst/grpc-web-generators](https://github.com/johanbrandhorst/grpc-web-generators)


| protoc         | version |
| ---------------| -------- |
| PROTOBUF |  23.3 |
| PROTOC_GEN_GO | v1.5.3 |
| PROTOC_GEN_GRPC |  1.4.2 |
| PROTOC_GEN_GRPC | 2.0.4 | 
| PROTOC_GEN_TS |  0.15.0 |


## Usage

    docker compose run protocomp bash

# building all APIs

    docker compose run protocomp protoc -I /protos \
        --go_out=plugins=grpc,paths=source_relative:/generated \
        --js_out=import_style=commonjs:/generated \
        --grpc-web_out=import_style=commonjs,mode=grpcwebtext:/generated \
        --grpc-python_out=/generated \
        /protos/<my_proto_file>.proto


### Python

### gRPC-Web

