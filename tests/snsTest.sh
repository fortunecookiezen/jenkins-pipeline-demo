#!/bin/sh
topic=$(terraform output topic_arn)
echo $topic "is the topic arn"
apk add --no-cache musl-dev go
CGO_ENABLED=0 go run tests/*.go