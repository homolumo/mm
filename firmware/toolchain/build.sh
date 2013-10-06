#!/bin/bash

# This script will try to build a barebone toolchain for lm32.
DESTDIR=/opt/cross/lm32-elf
download=true

set -ex

# first ensure that user can write to $DESTDIR
rm -rf $DESTDIR
mkdir -p $DESTDIR

# download all source code
# known working combinations: binutils 2.23 + gcc 4.5.3, binutils 2.23.2 + gcc 4.5.4
# known bad: binutils 2.23.2 + gcc 4.8.1: xgcc: internal compiler error: Segmentation fault (program cc1) when compiling libgcc/_ffssi2.o
#            binutils 2.23.2 + gcc 4.6.4: xgcc: internal compiler error: Segmentation fault (program cc1) when compiling libgcc/_clzdi2.o
#            binutils 2.23.2 + gcc 4.6.0: xgcc: internal compiler error: Segmentation fault (program cc1) when compiling libgcc/_clzdi2.o
GCCVER=4.5.4
BINUTILSVER=2.23.2
$download && wget -O binutils.tar.gz http://ftp.gnu.org/gnu/binutils/binutils-$BINUTILSVER.tar.gz
$download && wget -O gcc.tar.bz2 http://ftp.gnu.org/gnu/gcc/gcc-$GCCVER/gcc-core-$GCCVER.tar.bz2

# gcc pre-requisites
$download && wget -O gmp.tar.bz2 ftp://gcc.gnu.org/pub/gcc/infrastructure/gmp-4.3.2.tar.bz2
$download && wget -O mpc.tar.gz ftp://gcc.gnu.org/pub/gcc/infrastructure/mpc-0.8.1.tar.gz
$download && wget -O mpfr.tar.bz2 ftp://gcc.gnu.org/pub/gcc/infrastructure/mpfr-2.4.2.tar.bz2

rm -rf gcc-src binutils-src
mkdir -p gcc-src
mkdir -p binutils-src
tar xf binutils.tar.gz --strip-components 1 -C binutils-src
tar xf gcc.tar.bz2 --strip-components 1 -C gcc-src

mkdir gcc-src/gmp
tar xf gmp.tar.bz2 --strip-components 1 -C gcc-src/gmp
mkdir gcc-src/mpfr
tar xf mpfr.tar.bz2 --strip-components 1 -C gcc-src/mpfr
mkdir gcc-src/mpc
tar xf mpc.tar.gz --strip-components 1 -C gcc-src/mpc

# build binutils (due to version mismatch, we can't build binutils in gcc source tree)
mkdir binutils-src/build
cd binutils-src/build
../configure --prefix=$DESTDIR --target=lm32-barebone-elf
make -j4
make install
cd ../..

mkdir gcc-src/build
cd gcc-src/build
../configure --prefix=$DESTDIR --target=lm32-barebone-elf --with-gnu-as --with-gnu-ld --enable-language=c --disable-threads --disable-shared --disable-multilib --enable-sjlj-exceptions --disable-libssp --disable-lto
make -j4
make install
cd ../../

echo Done. You\'re free to \'rm -rf gcc-src/ binutils-src/\ \*.tar.\*\'
