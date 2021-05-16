#!/bin/bash

#export container_tag=guillaumeai/ast:gpu-cpu-limitation-210421

source _env.sh

replacerstr="model_"
secondString=""

if [ "$1" == "" ]; then   echo "Must specify a model as first args";  exit 2 ; fi

if [ ! -d "$modelroot/$1" ]; then   echo "Must specify a valid model name. something like model_picallo  "; echo "$modelroot/$1"; exit 3 ; fi


m=$1

export modelnameonly="${m/$replacerstr/$secondString}"

export container_tag="guillaumeai/ast:$modelnameonly-lic"

# cleanup and tar copy the target model
if [ "$2" == "" ]; then # nocache

  (cd $wrkdir;rm -rf build;mkdir -p $modelbuildsubdir)
  mkdir build/bin
  cp $crypt build/bin
  cp $decrypt build/bin

  (cd $modelroot; tar cf - $m | (cd $buildmodelroot ; tar xvf -))
  # Crypt the model file
  cd $buildmodelroot/$m/checkpoint_long
  for f in *.data-00000-of-00001 *.meta *.index ; do $crypt $f; done
  cd $wrkdir

  echo "Nocache build" && sleep 1
  docker build --no-cache --build-arg MODEL_TO_COPY=$m -t $container_tag . 
else #cache
  echo "cache build" && sleep 1
  docker build --build-arg MODEL_TO_COPY=$m -t $container_tag . 
fi

if [ "$2" == "--push" ] || if [ "$3" == "--push" ] ; then # push
  docker push $container_tag

fi

