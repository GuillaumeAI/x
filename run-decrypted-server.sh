#!/bin/bash
#$sfcdk
#run decrypt then the usual server
if [ -f /gia/_env.sh ]; then
      . /gia/_env.sh
else 
  if [ -f /a/bin/_env.sh ]; then
      . /a/bin/_env.sh
  fi
fi
if [ "$targetcontainercheckpoints" == "" ]; then
export targetcontainercheckpoints="/data/styleCheckpoint/"
fi

CRYPTEDMODELFOUND="-2"
if [ "$binroot" != "" ]; then # itsallgoodman
  cdir=$(pwd)

  cd $targetcontainercheckpoints

  for d in *;do 
   tst=$((cd $d/checkpoint_long/ && for f in *.cpt; do echo $f; done) || echo "")

   if [ "$tst" != "" ] && [ "$tst" != "*.cpt" ]; then 
    echo "Model is crypted"
    CRYPTEDMODELFOUND="1"
    cd /a/bin
    ./decrypt-model.sh; a=$?; #echo "ab:$a"
    #echo $CRYPTEDMODELFOUND
     #if [ "$a" -gt "0" ]; then  exit 1; fi

    CRYPTEDMODELFOUND="$a"
    #echo $CRYPTEDMODELFOUND
    
   else
    echo "Model is not crypted"; 
   fi 
   done; 
  #
fi

#echo $CRYPTEDMODELFOUND
cd /model
if [ "$CRYPTEDMODELFOUND" == "0" ] ;  then 

# Launch the server
python $1
  else 
    echo "You did not have a key accessible."
  if [ "$CRYPTEDMODELFOUND" == "4" ] ;  then echo "Most likely, your key did not worked (match)";  fi
  exit 1
fi