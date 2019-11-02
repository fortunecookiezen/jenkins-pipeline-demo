#!/bin/sh
topic=$(terraform output topic_arn)
echo $topic "is the topic arn"
apk add --no-cache make musl-dev go
go run tests/*.go