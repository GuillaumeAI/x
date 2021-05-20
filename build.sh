#!/bin/bash


################## Watcher Build #######################
# This file is ran by the watcher when a file changes





cdir=$(pwd)
bdir=$cdir/build
distdir=$cdir/dist
outdir=$cdir/out
watchdir=$cdir/astdrop
stylizedTargetDirBase=$cdir/stylized

mkdir -p $stylizedTargetDirBase
mkdir -p $bdir
mkdir -p $distdir
mkdir -p $outdir

donefile=$cdir/done.txt

lfile=$cdir/buildlog.txt

echo "-------------------------------" >> $lfile
echo "--1:$1--2:$2---3:$3----$4---------" >> $lfile
echo "---Building started at : $(date)  " >> $lfile


# Check if we have something so we dont run first for nothing
pwd
d=astdrop
if [ "$(ls $d/*  &> /dev/null)" != ""  ]; 
  then 
    echo Ya 
  else 
    echo nahhh
    echo "Nothing to process" >> $lfile
    #exit
fi


processme="" 
cd $watchdir &&\
for fc in *.{jpg,png}; do
  cd $watchdir
  if [ "$fc" != "*.png" ] && [ "$fc" != "*.jpg" ] && [ -e "$fc" ]; then
    #@states keep track of what we did
    clndropf=$(echo "$fc" | sed -e 's/dbg__//' | sed -e 's/dbg__ - //' | sed -e 's/ - //')
    echo "Cleaning files in drop mv $f $clndropf"
    mv "$fc" $bdir/$clndropf

    echo "$clndropf">> $donefile
    echo " Processing new file: $clndropf (was renamed from $f)" >>$lfile
    f="$clndropf"
    echo "We are moving in build to work on the new $f" >>$lfile
    cd $bdir

    ff="${f%.*}"
    # we create a dir foreach file so we have something clean
    stylizedTargetDir=$stylizedTargetDirBase/$ff
    mkdir -p $stylizedTargetDir

    ext=${f##*.}
    if [ "$ext" == "png" ];then
    #@a we convert  
      echo "Converting file from PNG to JPG:  convert $f $ff.jpg" >> $lfile
      convert "$f" "$ff.jpg" &&\
      rm "$f" &&\
      f=$ff.jpg  &&\    
      ext=${f##*.}
    fi
    #@state We will have our source with the stylized

    cp "$f" $stylizedTargetDir/"$ff"'__content__00.'$ext

    fclean=$(echo "$f" | sed -e 's/ /_/' | tr "'" "_" | sed -e 's/-/_/'  | sed -e 's/ /_/' | sed -e 's/-/_/' | sed -e 's/ - //')
    tfile=$bdir/$fclean

    if [ "$f" != "$tfile" ]; then     mv "$f" "$tfile"; fi

    processme+=$fclean' '
    # if [ -e "$tfile" ]; then echo "Cleanup $f"; rm "$f" ; fi
    
    if [ "$f" != "$fclean" ]; then 
      echo " file was cleared to target: $fclean" >> $lfile
    fi
  fi
 done
echo "Process this: $processme" >>$lfile
echo "Entering Build" >>$lfile
cd $bdir
if [ "$processme" != "" ] && [ "$processme" != " " ] 
then
  for f in $processme ; do 
    ff="${f%.*}"
    # we create a dir foreach file so we have something clean
    stylizedTargetDir=$stylizedTargetDirBase/$ff
    mkdir -p $stylizedTargetDir


    ff="${f%.*}"
    for p in 01 14 31 51 52 53 54 55 56 98; do
      echo "gia-ast $f $p --output dist" >> $lfile
      gia-ast $f $p  
      mv $ff'__stylized'* $stylizedTargetDir
    done

  done
fi
(chown -R jgi.jgi .)&

cd $stylizedTargetDir
echo "---Making CSM  " >> $lfile
(gis-csm -d --label >> $lfile && sleep 11 && chown -R jgi.jgi . && rm -rf build ) &


sleep 3

cd $cdir
($binroot/gallery_html_maker.sh stylized gal) &
sleep 5
#gixb gal/index.html &
(chown -R jgi.jgi .)&

echo "---Building ended  at : $(date)  " >> $lfile
echo "---------------------" >> $lfile
