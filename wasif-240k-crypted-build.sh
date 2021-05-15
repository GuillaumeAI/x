# sample call to create a docker that is crypted
source _env.sh
m="model_gia-ds-wassily_kandinsky_v1_210310_new-240ik"
crypt=$binroot/crypt.sh
decrypt=$binroot/decrypt.sh
(cd $wrkdir;rm -rf build;mkdir -p $modelbuildsubdir)
(cd $modelroot; tar cf - $m | (cd $buildmodelroot ; tar xvf -))
cd $buildmodelroot/$m/checkpoint_long
for f in * ; do $crypt $f; done
cd $wrkdir
