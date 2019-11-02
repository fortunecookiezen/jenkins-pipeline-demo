#!/bin/sh
topic =$(terraform output topic_arn)
echo $topic " is the topic arn"
