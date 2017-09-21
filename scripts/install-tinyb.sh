#!/bin/sh
#-------------------------------------------------------------------------------
# Copyright (C) 2017 Create-Net / FBK.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
#
# Contributors:
#     Create-Net / FBK - initial API and implementation
#-------------------------------------------------------------------------------

CURRDIR=`pwd`
CURRDIR=${1:-$CURRDIR}
BUILD=$CURRDIR/build
DEPS=$CURRDIR/deps
ARM=$2

TINYB_VER=0.5.0

if [ ! -e "$BUILD" ] ; then
  mkdir -p $BUILD
fi

if [ ! -e "$DEPS" ] ; then
  mkdir -p $DEPS
fi

cd $BUILD

if [ ! -e "$BUILD/tinyb" ] ; then
  git clone https://github.com/intel-iot-devkit/tinyb.git
  cd tinyb
  #git checkout "v$TINYB_VER"
  #For bluez5.4+ a patch needs to be applied to
  #handle "readValue()" api differences
  git checkout 6e580f494
fi

TINYB=$BUILD/tinyb

cd $TINYB

echo `pwd`

if [ "$ARM" = "" ]
then
    cmake . -DCMAKE_CXX_FLAGS="-std=c++11" -DCMAKE_INSTALL_PREFIX=$TINYB -DBUILDJAVA=ON
else
    echo "Building for ARM"
    cmake . -DCMAKE_CXX_FLAGS="-std=c++11" -DCMAKE_INSTALL_PREFIX=$TINYB -DBUILDJAVA=ON -DCMAKE_CXX_FLAGS:STRING='-m32 -march=i586'
fi

make tinyb
make install

cp $TINYB/java/tinyb.jar $DEPS
cp $TINYB/java/jni/*.so $DEPS
cp $TINYB/java/jni/*.so* $DEPS

mvn install:install-file -Dfile=$DEPS/tinyb.jar \
                         -DgroupId=tinyb \
                         -DartifactId=tinyb \
                         -Dversion=$TINYB_VER \
                         -Dpackaging=jar \
                         -DgeneratePom=true \
                         -DlocalRepositoryPath=$DEPS
