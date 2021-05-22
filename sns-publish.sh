#!/bin/bash

#source _topics.sh
tarn=$astiaarn

if [ "$1" == "" ] || [ "$2" == "" ] ||  [ "$tarn" == "" ]; then echo "usage: $0 <subject> <message> [topicARN]" ; exit 1;fi

read -r -d '' MSGCONTENT << MSG
##############################################################
#
#  $2
#
##############################################################
#
#
#
MSG

aws sns publish --topic-arn  $tarn --subject "$1" --message "$MSGCONTENT" &> /dev/null && echo "Message sent" || (echo "Failed to send" && exit 1)
