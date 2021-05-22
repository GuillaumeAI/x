#!/bin/bash


if [ "$1" == "" ] ; then echo "usage : $0 <topicname>" ; exit 1 ; fi

#Loading functions
if [ -e $binroot/__fn.sh ]; then
                source $binroot/__fn.sh $@
        else
              echo source /a/bin/__fn.sh
              source /a/bin/__fn.sh
fi
export LOG_ENABLED=y
export LOG_FILE=/var/log/gia/aws-sns.log

topicvarfile="_topics.sh"
tfile="_sns_topic__$1.json"
arnvarname="$1arn"
msg "Creating $arnvarname..."

arntmp=$( aws sns create-topic --name $1 | tee $tfile | awk '/Topic/ { print $2 }' | sed -e 's/"//g'  \
        && log_success "$1 created, See in $topicvarfile for the env var : echo \"\$arn_$1\"" \
	|| (log_failed "Failed to create $1" && exit 1) )
RES="$?"
if [ "$RES" != "0" ]; then 
	echo "Dohhh $RES" 
	exit 1
fi

source $topicvarfile &> /dev/null

defined $arnvarname \
	&& echo "$arnvarname was already defined in  $topicvarfile, all is probably fine" \
	|| ( echo "#------------------------"  >> $topicvarfile \
	&& echo "#------ $arntmp ----"  >> $topicvarfile \
	&& echo "export $arnvarname=\"$arntmp\"" >> $topicvarfile  && source $topicvarfile  )




#echo "export arn_topic__x__aws_cli__sns__210522_dummy=$(cat _sns_topic__x__aws_cli__sns__210522_dummy.json | awk '/Topic/ { print $2 }')"

