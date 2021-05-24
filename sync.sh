#!/bin/bash

dttagday=$(date +'%y%m%d')
dtday=$(date +'%y-%m-%d')
#@STCGoal Sync latest
if [ "$1" == "" ] ; then 
  curl https://app.simplenote.com/p/9PyP63 --output _TMP_buts.html
  rm buts.html part2.html
fi

#@STCGoal Prep it for tranformation
rm buts.md
wdir=build
rm -rf $wdir
mkdir -p $wdir

o=0
p2=0
while read l; do
  if [[ $l == *"note-detail-markdown"* ]];
  then # we go
    o=1;
    l=$(echo "$l" | sed -e 's/<\/div>//g')
     fi
  if [[ $l == *".note"* ]] ;  then #we re done
  o=0; fi
  if  [[ $l == *"XPART2"* ]];  then #we re done for chart
  p2=1; l=$(echo "$l" | sed -e 's/XPART2//g'); fi
  
  if [ "$o" == 1 ] ; then 
    if [[ $l != *"<div"* ]] && [[ $l != *"</div"* ]] ; then #only if not div

    if  [ "$p2" == 0 ]; then  
      echo "$l" >> buts.html
    else echo "$l" >> part2.html 
     fi
      #node html2markdown.js >> buts.md
    fi

  fi

done <_TMP_buts.html
#@state We have buts.html without header etc
#html=$(cat buts.html | tr "\n" " ")
#echo "$html" > tmp.html
#echo "$html"
echo "----------Processing to convert to MD--------"
node html2markdown.js > buts.md
#rm _TMP_buts.html


#@STCGoal get out daily work todo
cs=v
c=0
while read l; do
  if  [[ "$l" == *"@v"* ]];  then #@v
    cs=v
    v=$'\n----\n'   
    c=$(expr $c + 1 )
    else if  [[ "$l" == *"@a"* ]];  then  #@a
    cs=a
    a=$'\n----\n' 
    else if  [[ "$l" == *"@CR"* ]];  then #@CR
    cs=cr
    cs=$'\n----\n' 
    fi;fi;fi

  twdir=$wdir/$c
  mkdir -p $twdir

  if [ "$cs" == "v" ]; then #@v
  #@a   
    echo "$l" >> $twdir/v.md
    v+=$' \n'"$l"
    else if [ "$cs" == "a" ]; then 
    echo "$l" >> $twdir/a.md
    a+=$' \n'"$l"    
    else if [ "$cs" == "cr" ]; then #@CR
      echo "$l" >> $twdir/cr.md
      cr+=$' \n'"$l"    

  fi;fi;fi

#@a a DT.md file of today with the Goal
  if  [[ "$l" == *"$dtday"* ]];  then
      echo "$v  " >> $wdir/today.md
      echo "$l" >> $wdir/today.md
  fi
done <buts.md


#clean
rmdir $wdir/* &> /dev/null