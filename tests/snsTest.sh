#!/bin/sh
#$topic = $(terraform output topic_arn)
echo $(terraform output topic_arn) " is the topic arn"
