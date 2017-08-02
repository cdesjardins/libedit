#!/bin/bash

RELEASE=$1

if [ -z $RELEASE ] ; then
    echo "Release label required (netbsd-7-1-RELEASE)"
    exit 1
fi

export CVSROOT="anoncvs@anoncvs.NetBSD.org:/cvsroot"
export CVS_RSH="ssh"

TMPD=`mktemp -d netbsd-XXXXXXXXX`
pushd .
echo $TMPD
cd $TMPD 
cvs checkout -r $RELEASE -P src/lib/libedit
cvs checkout -r $RELEASE -P src/lib/libc
cvs checkout -r $RELEASE -P src/include
popd

if [ ! -e src ]; then
    mkdir src
fi
cp -R $TMPD/src/lib/libedit/* $TMPD/src/lib/libc/gen/vis.c $TMPD/src/include/vis.h $TMPD/src/lib/libc/include/namespace.h src
#rm -rf $TMPD
find -name CVS -type d | xargs rm -rf

if [ ! -e include ]; then
    mkdir include
fi
rm src/config.h
sh src/makelist -h src/vi.c > include/vi.h
sh src/makelist -h src/emacs.c > include/emacs.h
sh src/makelist -h src/common.c > include/common.h

sh src/makelist -fh include/vi.h include/emacs.h include/common.h > include/fcns.h
sh src/makelist -bh src/vi.c src/emacs.c src/common.c > include/help.h
sh src/makelist -fc include/vi.h include/emacs.h include/common.h > include/func.h

