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



part2file=$wdir/$PART2NAME
stcfilebase=$wdir/$STCBASE
stcfilehtml=$stcfilebase.html
stcfilemd=$stcfilebase.md
tmphtml=$wdir/_TMP_$STCBASE.html
lvar part2file stcfilebase stcfilehtml stcfilemd tmphtml

#@STCGoal an Archives of my goals
previoushtml=/tmp/sync_previous__TMP_$STCBASE.html
cp build/_TMP_buts.html $previoushtml &> /dev/null #Know if we got changes 
rm -rf $wdir $ddir
mkdir -p $wdir
mkdir -p $sdir
mkdir -p $ddir


yesterdayfilepath=$wdir/$YESTERDAYFILENAME
todayfilepath=$wdir/$TODAYFILENAME
tomorrowfilepath=$wdir/$TOMORROYFILENAME

bychartname=by-chart
bychartwdir=$wdir/$bychartname

lvar yesterdayfilepath todayfilepath tomorrowfilepath
export GOTCHANGES=0
#@STCGoal Sync latest
if [ "$1" != "--skip" ]  || [ "$2" != "--skip" ]; then
  log_status "Refreshing data started" INFO
  curl $SNOTEPAGE --output $tmphtml --silent && log_success "Data refreshed" || log_failed "Data did not refresh"
  if [ "$1" == "--onlynew" ]; then
    export tstgotchanges=$(diff $tmphtml $previoushtml || exit 1 )
    (has_value tstgotchanges || exit 1) && msg_info "Changes detected" || (msg_alert "No changes detected...exiting" ; msg_info "use noargs to process anyway";exit 1) || exit 1
  fi
  sleep 1
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
#@state We have a cleared HTML file ready to CONVERT

echo "--------Processing to convert to MD--------"
#@a converted HTML TO a Markdown file
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


  #@STCGoal Separated elements pf charts by chart folder
    twdir=$bychartwdir/chart-$c
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

#tomorrow 

  #@a a DT.md file of tomorrow with the Goal
    if  [[ "$l" == *"$tomorrow"* ]];  then
        echo "$v  " >> $tomorrowfilepath
        echo "$l" >> $tomorrowfilepath
    fi
  #@a a DT.md file of today with the Goal
    if  [[ "$l" == *"$today"* ]];  then
        echo "$v  " >> $todayfilepath
        echo "$l" >> $todayfilepath
    fi

  #@a a DT.md file of yesterday with the Goal
    if  [[ "$l" == *"$yesterday"* ]];  then
        echo "$v  " >> $yesterdayfilepath
        echo "$l" >> $yesterdayfilepath
    fi
    mix="$v"$'\n\n'"$a"$'\n\n'"$cr"
    arr[${#arr[@]}]="$mix"

done <$stcfilemd

log_notice "@STCGoal get out daily work todo Ended "

#----------------------------------
# A file another way, why ??
c=1
bdir=$wdir/by-someway

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
rmdir $wdir/* &> /dev/null 
rmdir $wdir/**/* &> /dev/null 

cp $todayfilepath $ddir
cp $yesterdayfilepath $ddir
cp $tomorrowfilepath $ddir
tldir=$ddir/../tl ; mkdir -p $tldir
cp $todayfilepath $tldir/$today.md
#cp $yesterdayfilepath $tldir/$yesterday.md
cp $tomorrowfilepath $tldir/$tomorrow.md

cp -r $bychartwdir $ddir/$bychartname
mkdir -p $ddir/stc
cp $wdir/stc* $ddir/stc

#clean
rmdir $wdir/* &> /dev/null

#@STCGoal Distributable results

cd $cdir
export onlinedistrootrepo=/a/src/buts/docs
archns=arch
todayarchivesroot=$onlinedistrootrepo/$archns
todayrelpath=$archns/$today
todayarchives=$todayarchivesroot/$today
mkdir -p  $todayarchives
cd $onlinedistrootrepo
git add $todayrelpath/* &> /dev/null
sleep 1
tar cf - * | (cd $todayarchives;sleep 1;tar xf -)
rm -rf  $todayarchives/$archns #cleanup subdir arch
git pull&> /dev/null
git commit $todayrelpath -m "arch:$today" &> /dev/null&& git push&> /dev/null

cd $cdir
cd $ddir || exit 1
du * | awk '/.md/ { print "## ["$2"]("$2")\n" }' > README.md
echo "<hr>">> README.md
du -a stc | awk '/.md/ { print "* ["$2"]("$2")\n" }' | sort >> README.md
echo "<hr>">> README.md
sed -i 's/\.md\]/\]/g' README.md #Clean link name
sed -i 's/\[stc\//\[/g' README.md #Clean link name
echo "  " >> README.md
echo "----" >> README.md
echo "  " >> README.md
echo "[ARCH](arch/README.md)" >> README.md
cd $todayarchivesroot
mkdir -p $ddir/$archns
for d in * ; do echo "[$d]($d/README.md)" >> $ddir/$archns/README.md ; done
sleep 1
cd $ddir 
echo "  " >> README.md
echo "----" >> README.md
echo "  " >> README.md
echo "[Yesterday](yesterday.md)" >> README.md
echo "[Tomorrow](tomorroy.md)" >> README.md
tar cf - * | \
  (cd $onlinedistrootrepo && sleep 1 && pwd && tar xf - && \
  git add * &> /dev/null;git commit . -m "dist" &> /dev/null; git push &>/dev/null)

cd $cdir
echo DONE
echo "Read this online at : https://jgwill.github.io/buts/"
$binroot/sns-publish.sh "Buts updated:" "Read this online at : https://jgwill.github.io/buts/" &> /dev/null