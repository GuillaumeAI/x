#!/bin/bash

# this file is meant to be used in the container and run when it boot to decrypt using env var or a mounted file defining the variable

if [ -f /a/bin/_env.sh ]; then
    . /a/bin/_env.sh
else 
  if [ -f _env.sh ]; then
        . _env.sh
  fi
fi


#goto where a model is
cd $targetcontainercheckpoints
if [ "$sfcdk" != "" ]; then # We have a decrypt key
  for d in *; do
    echo "Decrypting $d"
    # DeCrypt the model file
    cd $d/checkpoint_long
    for f in *.cpt ; do 
      if [ -f $f ] ; then   
       $decrypt $f  &> /dev/null;a=$?; #echo $a
     #ccdecrypt -E sfcdk $1  &> /dev/null ;a=$?;     # echo "a:$a"
        if [ "$a" -gt "0" ]; then 
        echo "dohhhhhhhhhhhhhhh"
         if [ $a == 4 ]; then  echo "Crypting key does not match";exit 4;fi
        exit $a
         fi
      fi
      
     done
    cd ../..
  done
else
  echo "Sorry, env:sfcdk not defined or mounted path isnt right. define a var SFCDK using -e =MYKEY in docker  or mount the dir where you put .giasecrets with your exported key (sfcdk) in /gia/etc, /config, /work"
  echo ">>>.giasecrets"
  echo "export sfcdk=MYKEY"
  echo "docker ... -e SFCDK=MYKEY"
  echo "docker ... -v $HOME:/config"
fi
