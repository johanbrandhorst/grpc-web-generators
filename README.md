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

docker compose run -v `pwd`/api:/api -v `pwd`/time/goclient:/goclient -v `pwd`/frontend/src/jsclient:/jsclient jfbrandhorst/grpc-web-generators protoc -I /api \
	  --go_out=plugins=grpc,paths=source_relative:/goclient \
	  --js_out=import_style=commonjs:/jsclient \
	  --grpc-web_out=import_style=commonjs,mode=grpcwebtext:/jsclient \
	 /api/time/v1/time_service.proto


### Python

### gRPC-Web

