
source _topics.sh
tarn=$dummytopic6arn
#email=jgi@jgwill.com

aws sns publish --topic-arn  $tarn --subject "ability to notify" --message "$1"
#aws sns publish --topic-arn arn:aws:sns:us-west-2:123456789012:my-topic --message "Hello World!"





#aws sns subscribe --topic-arn $tarn --protocol email --notification-endpoint $email

#aws sns subscribe --topic-arn arn:aws:sns:us-west-2:123456789012:my-topic --protocol email --notification-endpoint saanvi@example.com
