#!/bin/bash



if [ "$1" == "" ] || [ "$2" == "" ] ; then echo "usage: $0 <topicarn> <email>";echo "use sns-list to get topics" ; exit 1;fi
email="$2"
tarn="$1"



aws sns subscribe --topic-arn $tarn --protocol email --notification-endpoint $email

#aws sns subscribe --topic-arn arn:aws:sns:us-west-2:123456789012:my-topic --protocol email --notification-endpoint saanvi@example.com
