export list_to_dockerize=list_to_dockerize.txt
export modelroot=/a/model/models
export wrkdir=/a/d/gia-model-dockerizing-2104
#cleaning and making  build folder
modelbuildsubdir=build/models

export targetcontainercheckpoints="/data/styleCheckpoint/"

export buildmodelroot=$wrkdir/$modelbuildsubdir
if [ "$binroot" == "" ]; then export binroot=/a/bin ;fi
export crypt=$binroot/crypt.sh
export decrypt=$binroot/decrypt.sh






if [ "$SFCDK" != "" ]; then # we have a var
    export sfcdk=$SFCDK
else  # look in files
    if [ -f /work/.giasecrets ]; then
        . /work/.giasecrets
    fi
    if [ -f /config/.giasecrets ]; then
        . /config/.giasecrets
    fi
    if [ -f /gia/etc/.giasecrets ]; then
        . /gia/etc/.giasecrets
    fi
    if [ -f /a/etc/.giasecrets ]; then
        . /a/etc/.giasecrets
    fi

    if [ -f /gia/_env.sh ]; then
        . /gia/_env.sh
    fi

    if [ -f /work/giasecrets.txt ]; then
        . /work/giasecrets.txt
    fi
    if [ -f /config/giasecrets.txt ]; then
        . /config/giasecrets.txt
    fi
    if [ -f /gia/etc/giasecrets.txt ]; then
        . /gia/etc/giasecrets.txt
    fi
    if [ -f /a/etc/giasecrets.txt ]; then
        . /a/etc/giasecrets.txt
    fi
fi
