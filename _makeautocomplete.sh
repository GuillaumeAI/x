#!/bin/bash

for f in $(cat dbg.txt); do
  DISCARTED=0
  for o in $(cat done.txt); do
    if [ "$o" == "$f" ] ; then DISCARTED=1 ; fi
  done
    ext=${f##*.}
    if [ "$f" != "_CSM" ] &&  [ "$ext" == "jpg" ] ||  [ "$ext" == "png" ] &&  [ "$DISCARTED" == "0" ] ; then
    echo "$f"
    fi
done