#!/bin/sh
topic=$(terraform output topic_arn)
echo $topic "is the topic arn"
apk add --no-cache musl-dev go
go get -u github.com/aws/aws-sdk-go/...
CGO_ENABLED=0 go build -o snsTest tests/snsTest.go
ls -l snsTest
./snsTest -e "phillips.james@gmail.com" -t $topic
# echo "access key is" $AWS_ACCESS_KEY_ID