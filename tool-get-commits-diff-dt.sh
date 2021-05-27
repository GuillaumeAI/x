
export onlinedistrootrepo=/a/src/buts/docs

cdir=$(pwd)
# get a view of what changed 
dttag=$(date +'%y%m%d%H%M%S')
ytag="$(date +'%y-')"
cd $onlinedistrootrepo
commits=$(git log README.md| awk '/commit/ { print $2 }')
echo "$commits" > $cdir/latest-commits.txt

latestcommit=""
for c in "$commits" ; do 
  git diff $c  | grep "* $(date +'%y-')" | grep "++" | sed -e 's/\+\+//g'>> $cdir/$dttag.diff.txt
  if [ "$latestcommit" == "" ]; then latestcommit="$c"; fi
done  
         
cd $cdir     

echo "------------TODAY------DIFF---------  "
(cd $onlinedistrootrepo; git diff $latestcommit today.md)

echo "------------YESTERDAY------DIFF---------  "
(cd $onlinedistrootrepo; git diff $latestcommit yesterday.md)

echo "------------TOMORROW------DIFF---------  "
(cd $onlinedistrootrepo; git diff $latestcommit tomorrow.md)

#cat $dttag.diff.txt | more










#@BUGGED (cd $onlinedistrootrepo; commits=$(git log README.md| awk '/commit/ { print $2 }'); for c in "$commits" ; do git diff $c | sed -e 's/\-\-/\-/g'  | sed -e 's/\-\-/\-/g'| sed -e 's/\+\+/\+/g'  | sed -e 's/\+\+/\+/g' | sed -e 's/  / /g' | sed -e 's/\t//g'  | sed -e 's/\-\-  //g'| sed -e 's/ \+//g' | sed -e 's/\n /\n/g'| grep "* $(date +'%y-')" | sed -e 's/ \+//g'| sed -e 's/  / /g';done ) > $dttag.diff.txt
#(cd $onlinedistrootrepo; commits=$(git log README.md| awk '/commit/ { print $2 }');echo "$commits"; for c in "$commits" ; do git diff $c | grep "$(date +'%y-')" | more;done )

