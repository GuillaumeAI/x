#!/bin/bash

f=$1
src=/mnt/c/Users/jeang/Dropbox/lib/datasets/DavidBouchardGagnon

fsrc=$src/$f

targetwatch=$(pwd)'/astdrop/dbg__'$f
cp $fsrc $targetwatch
