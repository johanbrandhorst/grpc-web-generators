# usage

to build javascript gRPC-web interface run:


    docker compose run -v `pwd`/api:/api -v `pwd`/time/goclient:/goclient -v `pwd`/frontend/src/jsclient:/jsclient ghcr.io/larasuite/grpc_generators:latest protoc -I /api \
        --go_out=plugins=grpc,paths=source_relative:/goclient \
        --js_out=import_style=commonjs:/jsclient \
        --grpc-web_out=import_style=commonjs,mode=grpcwebtext:/jsclient \
        /api/time/v1/time_service.proto


## gRPC-Web Usage


https://github.com/grpc/grpc-web

and

https://torq.io/blog/grpc-web-using-grpc-in-your-front-end-application/
