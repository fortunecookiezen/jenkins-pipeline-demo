#!/bin/sh
topic=$(terraform output topic_arn)
echo $topic "is the topic arn"
apk add --no-cache musl-dev go
go get -u github.com/aws/aws-sdk-go/...
CGO_ENABLED=0 go build tests/*.go