source /varsrc

cd "$HOME_FOLDER"

echo " - Installing CCCD base"

echo "   - Updating cil custom location [source base: '$CCCD_DIRTY'; target: '$HOME_FOLDER/$CREST_FOLDER/cil/src/']"

cd "$CCCD_DIRTY"
# i can not identify, why 'M.theMachine' is assumed unbound (it seems to be, the patch was made for a newer crest
# which is either no longer available or corrupted)
# Luckily i can exhibit full toolchain control:
# let M.theMachine = M.gcc
sed -i '80s/.*/let theMachine : M.mach ref = ref M.gcc/' bashScripts/customfiles/cil.ml
# promoting :) [lucky guy/girl]
sed -i 's/M.theMachine/theMachine/' bashScripts/customfiles/cil.ml
# we do need a bool for the patch: this is necessary to provide information about bool:
# | IBool -> !M.theMachine.M.sizeof_bool in cil.ml patch L1930
# sed -i '76s/^/printf("\t sizeof_bool           = %d;\n", (int)sizeof(bool));\n/' "$HOME_FOLDER/$CREST_FOLDER/cil/src/machdep.c"
# => we do not do this but kill, because machdep.c changes have a lot of aother problems
# same with 2101 containing alignof bool
sed -i '1931d;2101d' bashScripts/customfiles/cil.ml
# furthermore we guess the alignment as we do know it but have no control over its init in cil
sed -i 's/!theMachine.M.alignof_aligned/1/' bashScripts/customfiles/cil.ml
# and we use the gcc valist as i do know there is nothing else [gcc only built on fedora]
sed -i 's/!theMachine.M.__builtin_va_list/M.gccHas__builtin_va_list/' bashScripts/customfiles/cil.ml

# Furthermore, we have to kill envMachine as it is unbound as well and not present in 0.1.1 this requires as
# to remove a multiline match. We will use perl regex as i am literally out of options (this is ~hour 20 after
# starting to patch cccd :D)
# https://unix.stackexchange.com/questions/181180/replace-multiline-string-in-files
perl -i -p0e 's/begin\n *match !envMachine with\n *Some machine -> theMachine := machine\n *\| None -> theMachine := if !msvcMode then M\.msvc else M\.gcc\n *end;\n/theMachine := if !msvcMode then M.msvc else M.gcc;/s' bashScripts/customfiles/cil.ml
# kill the origin:
sed -i 's/let envMachine : M.mach option ref = ref None//' bashScripts/customfiles/cil.ml

# well.. as it turns out there is an interface, that we have to comply to...
# 271 removes kind delcaration, 1255 is TInt based type constructor of boolType
# 1284 is the IBool control for isSigned; 1643 for d_ikind
# 2044 is for rank; 2101 kills the alignof
# Note: we cant just remove everythin with IBool as there are longer statements """needing""" it
# 2569-2573 is special case handling for bools; further we need to remoove a guard in the next line
# same with 6125-6127 which is the mkCastT conversion
sed -i '271d;1255d;1284d;1643d;2044d;2101d;2569,2573d;6125,6127d' bashScripts/customfiles/cil.ml # NOTE: this is dependent on del of L80
# killing the guard
sed -i  "2563s/\| Const(CInt64(i,k,_)), TInt(nk,a)/Const(CInt64(i,k,_)), TInt(nk,a)/" bashScripts/customfiles/cil.ml
sed -i  "6114s/\| TInt(newik, \[\]), Const(CInt64(i, _, _)) -> kinteger64 newik i/TInt(newik, []), Const(CInt64(i, _, _)) -> kinteger64 newik i/" bashScripts/customfiles/cil.ml

# TODO: pipe escape deos not work

# next problem is enuminfo which is patched inconsistently:
sed -i 's/mutable ekind: ikind;//' bashScripts/customfiles/cil.ml
sed -i 's/TEnum(ei, _) -> alignOf_int (TInt(ei.ekind, \[\]))/TEnum _ -> !theMachine.M.alignof_enum/' bashScripts/customfiles/cil.ml
sed -i 's/TEnum (ei, _) -> 8 \* (bitsSizeOf (TInt(ei.ekind, \[\])))/TEnum _ -> 8 * !theMachine.M.sizeof_enum/' bashScripts/customfiles/cil.ml
sed -i 's/TEnum (ei, _) -> ei.ekind/TEnum _ -> IInt/' bashScripts/customfiles/cil.ml

# interface of Temp Variables:
sed -i 's/makeTempVar fdec ?(insert = true)/makeTempVar fdec/' bashScripts/customfiles/cil.ml
sed -i 's/let vi = makeLocalVar fdec ~insert name typ in/let vi = makeLocalVar fdec name typ in/' bashScripts/customfiles/cil.ml

# no we have to deal with 'descriptiveCilPrinterClass':
sed -i 's/(enable: bool)//' bashScripts/customfiles/cil.ml
sed -i 's/if enable then/if true then/' bashScripts/customfiles/cil.ml # :)
# update callsites:
sed -i 's/(new descriptiveCilPrinterClass true)/(new descriptiveCilPrinterClass)/' bashScripts/customfiles/cil.ml

# Debug stuff:
cat -n bashScripts/customfiles/cil.ml | head -n4820 | tail -n10

cp bashScripts/customfiles/cil.ml "$HOME_FOLDER/$CREST_FOLDER/cil/src/"

echo "    - installing cil"
cd "$HOME_FOLDER/$CREST_FOLDER/cil"
chmod +x ./configure
eval $(opam env)

echo "    - no libstr patch"

# opam patch [https://stackoverflow.com/questions/13584629/ocaml-compile-error-usr-bin-ld-cannot-find-lstr]
# cd "/home/opam/.opam/$OCAML_VERSION/lib/ocaml/"
# ln -s libcamlstr.a libstr.a
# ln -s str.a libstr.a # naming update

echo "    - installing yices locally, because all links are dead"
echo "      - building custom gmp"

cd "$HOME_FOLDER/"
# unpack [ breaks with long length ]
# tar -xzvf /$GMP
# cd "$HOME_FOLDER/$(basename $GMP .tar.gz)"
# ./configure
# make
# make check # "very important"


cd "$HOME_FOLDER/"
# auto yices installer TODO: check if necessary
# Based on ocamlyices https://github.com/polazarus/ocamlyices
wget -q -O- http://git.io/sWxMmg | sh -s "/$YICES" --prefix "$YICES_TARGET" --libdir=$YICES_LIB


cd "$HOME_FOLDER/$CREST_FOLDER/cil"

# after countless of tries (and hours) it turns out, that perfcount.c.in has an error when used with C99 "inline"
# we ahve to patch 'ocamlutil>perfcount.c.in' regarding line 59
sed -i '59s/.*/unsigned longlong read_ppc(void);/' ocamlutil/perfcount.c.in
# with this we declare an otherwise supersedeable inline

# interestingly the old '/usr/include/bits/mathcalls-helper-functions.h[20:12-28] : syntax error'
# seems to be broken since around 2018 (https://github.com/samee/obliv-c/issues/48)
# any alias injection fails. Therefore we will modify Cilly.pm as it is the core module defining CPP
# in line 1879 solid. We will append the necessary definitions simiar to the alias inject:
# alias gcc='gcc -std=gnu++98 -D _Float128=double'
sed -i "1879s/.*/      CPP =>  [@native_cc, '-D_GNUCC', '-E', '-std=gnu++98', '-D _Float128=double'],/" ../cil/lib/Cilly.pm

./configure
make
make test
make install

# no we have to install crest itself
cd ../src

# the default makefile is "damaged" in the way it deals with narrowing conversions. we patch that
# we have to allow otherwise forbidden narrowing conversions
sed -i 's/CXXFLAGS = $(CFLAGS)/CXXFLAGS = $(CFLAGS) -std=gnu++98/' Makefile

## furhtermore we do have to patch base/symbolic_expression.cc
## it uses functions declared in cstdio
sed -i '13s/.*/#include <cstdio>/' base/symbolic_expression.cc
sed -i '13s/.*/#include <cstdio>/' run_crest/run_crest.cc

# we have to add gmp manually [via -lgmp] :)
make YICES_DIR="$YICES_TARGET/yices-1.0.13-i686-pc-linux-gnu" LOADLIBES="-lyices -lrt -lgmp"