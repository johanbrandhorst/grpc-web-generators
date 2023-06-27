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

# building all APIs

    docker compose run --rm protocomp protoc -I/protos \
        --go_out=plugins=grpc,paths=source_relative:/generated \
        --js_out=import_style=commonjs:/generated \
        --grpc-web_out=import_style=commonjs,mode=grpcwebtext:/generated \
        /protos/helloworld.proto

    docker compose down


### Python
    docker compose run --rm protocomp python3 -m grpc_tools.protoc -I/protos \
        --python_out=/generated \
        --pyi_out=/generated \
        --grpc_python_out=/generated \
        /protos/helloworld.proto

## Troubleshooting

    docker compose run protocomp bash
