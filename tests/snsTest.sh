#!/bin/sh
apk add --no-cache musl-dev go
go get -u github.com/aws/aws-sdk-go/...
CGO_ENABLED=0 go build -o snsTest tests/snsTest.go
topic=$(terraform output topic_arn)
./snsTest -e "phillips.james@gmail.com" -t $topic
