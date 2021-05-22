
source _topics.sh
tarn=$dummytopic6arn
#email=jgi@jgwill.com
if [ "$1" == "" ] || [ "$2" == "" ] ; then echo "usage: $0 <subject> <message" ; exit 1;fi

read -r -d '' MSGCONTENT << MSG
##############################################################
#							     #
#  $2
#							     #
##############################################################
MSG

aws sns publish --topic-arn  $tarn --subject "$1" --message "$MSGCONTENT"
#aws sns publish --topic-arn arn:aws:sns:us-west-2:123456789012:my-topic --message "Hello World!"





#aws sns subscribe --topic-arn $tarn --protocol email --notification-endpoint $email

#aws sns subscribe --topic-arn arn:aws:sns:us-west-2:123456789012:my-topic --protocol email --notification-endpoint saanvi@example.com
