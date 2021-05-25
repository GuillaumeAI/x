#!/bin/bash
SYNCDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [ -e $binroot/__fn.sh ] && [ "$FNLOADED" == "" ]; then
   source $binroot/__fn.sh $@
fi
LOG_FILE=log/sync.log
LOG_ENABLED=y
DEBUG=1
mkdir -p log
msg "STC Syng Starting"
log_status "----------STARTED----" INFO
#html2markdownbin=./html2markdown.js
. .env


#HTML2MARKDOWNBIN=./html2markdown.js
daynum=$(date +'%d')
yearmonth=$(date +'%y-%m')
yesterday=$(expr $daynum - 1)
tomorrow=$(expr $daynum + 1)
dttagday=$(date +'%y%m%d')
today=$(date +'%y-%m-%d')
yesterday="$yearmonth-$yesterday"
tomorrow="$yearmonth-$tomorrow"
lvar tomorrow today yesterday
sdir=$SYNCDIR/$SDIR
wdir=$SYNCDIR/$WDIR
ddir=$SYNCDIR/$DDIR
lvar sdir wdir ddir
rm -rf $wdir $ddir
mkdir -p $wdir
mkdir -p $sdir
mkdir -p $ddir

part2file=$wdir/$PART2NAME
stcfilebase=$wdir/$STCBASE
stcfilehtml=$stcfilebase.html
stcfilemd=$stcfilebase.md
tmphtml=$wdir/_TMP_$STCBASE.html
lvar part2file stcfilebase stcfilehtml stcfilemd tmphtml

yesterdayfilepath=$wdir/$YESTERDAYFILENAME
todayfilepath=$wdir/$TODAYFILENAME
tomorrowfilepath=$wdir/$TOMORROYFILENAME

lvar yesterdayfilepath todayfilepath tomorrowfilepath

#@STCGoal Sync latest
if [ "$1" != "--skip" ]  || [ "$2" != "--skip" ]; then
  log_status "Refreshing data started" INFO
  curl $SNOTEPAGE --output $tmphtml --silent && log_success "Data refreshed" || log_failed "Data did not refresh"
  log_info "Cleaning $sdir"
  rm -rf $sdir/  &> /dev/null && log_success "Data cleared" || log_warning "Data were not cleared"
  # ||(echo "could not remove $sdir data" &&  exit 1)
fi


#@STCGoal Prep it for tranformation


o=0
p2=0
while read l; do
 
  if [[ $l == *"note-detail-markdown"* ]];
  then # we go
    o=1;
    l=$(echo "$l" | sed -e 's/<\/div>//g')
    lvar o l
     fi
  if [[ $l == *".note"* ]] ;  then #we re done
  o=0 ;   lvar c o l;   fi
  if  [[ $l == *"XPART2"* ]];  then #we re done for chart
  p2=1; l=$(echo "$l" | sed -e 's/XPART2//g')
  lvar c p2 l ; fi

  if [ "$o" == 1 ] ; then
    if [[ $l != *"<div"* ]] && [[ $l != *"</div"* ]] ; then #only if not div

    if  [ "$p2" == 0 ]; then
      echo "$l" >> $stcfilehtml
    else echo "$l" >> $part2file
     fi
    fi

  fi

done <$tmphtml
#@state We have $stcfilehtml without header etc

echo "--------Processing to convert to MD--------"

$HTML2MARKDOWNBIN > $stcfilemd
lvar HTML2MARKDOWNBIN stcfilemd
#rm _TMP_$stcfilehtml


#@STCGoal get out daily work todo
cs=none
c=0
arr=()
while read l; do
  if  [[ "$l" == *"@v"* ]];  then #@v
    cs=v
    v=$'\n----\n'
    c=$(expr $c + 1 )
    lvar c cs v
    a=""
    cr=""
    else if  [[ "$l" == *"@a"* ]];  then  #@a
    cs=a
    a=$'\n----\n'
    lvar c cs a
    else if  [[ "$l" == *"@CR"* ]];  then #@CR
    cs=cr
    cr=$'\n----\n'
    lvar c cs cr
    fi;fi;fi
    log "-------------"
    #lvar c cs v a cr 

  twdir=$wdir/by-chart/chart-$c
  mkdir -p $twdir
  stcfile=$wdir/stc-$c.md
  lvar twdir stcfile
  if [ "$cs" == "v" ]; then #@v
  #@a
    echo "$l" >> $twdir/v.md
    echo "$l" >> $stcfile
    v+=$' \n'"$l"
    else if [ "$cs" == "a" ]; then
    echo "$l" >> $twdir/a.md
    echo "$l" >> $stcfile
    a+=$' \n'"$l"
    else if [ "$cs" == "cr" ]; then #@CR
      echo "$l" >> $twdir/cr.md
    echo "$l" >> $stcfile
      cr+=$' \n'"$l"

  fi;fi;fi


#@a a DT.md file of today with the Goal
  if  [[ "$l" == *"$today"* ]];  then
      echo "$v  " >> $todayfilepath
      echo "$l" >> $todayfilepath
  fi
  mix="$v"$'\n\n'"$a"$'\n\n'"$cr"
  arr[${#arr[@]}]="$mix"

done <$stcfilemd

log_notice "@STCGoal get out daily work todo Ended "

#----------------------------------
# A file another way, why ??
c=1
bdir=$wdir/by-someway
exit
mkdir -p $bdir

for a in "${arr[@]}"; do
    echo "$c: $a" >> debug_arr.md
    c=$(expr $c + 1 )
done


# c=1
# for a in "${arr[@]}"; do
#     stcfileB=$bdir/stc-$c.md
#     echo "---TST----$a" >> $stcfileB
#     if  [[ "$a" == *"@v"* ]];  then #@v
#      c=$(expr $c + 1 ) 
#     fi
# done
# log_notice "Ended A file another way, why ?"

lvar todayfilepath
cp $todayfilepath $ddir

#clean
rmdir $wdir/* &> /dev/null
echo DONE