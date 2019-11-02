#!/bin/sh
topic=$(terraform output topic_arn)
echo $topic "is the topic arn"
apk add --no-cache make gcc build-base musl-dev go
CGO_ENABLED=0 go run tests/*.go