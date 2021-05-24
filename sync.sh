#!/bin/bash

#@STCGoal Sync latest
if [ "$1" == "" ] ; then curl https://app.simplenote.com/p/9PyP63 --output _TMP_buts.html
fi

#@STCGoal Prep it for tranformation
rm buts.html drop.md

o=0
while read l; do
  if [[ $l == *"note-detail-markdown"* ]];
  then # we go
    o=1; fi
  if [[ $l == *".note"* ]];  then #we re done
  o=0; fi
  
  if [ "$o" == 1 ] ; then 
    echo "$l" > line.html
    node html2markdown.js >> drop.md
  fi

done <_TMP_buts.html

#rm _TMP_buts.html

