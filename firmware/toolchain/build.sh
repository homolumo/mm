#!/bin/bash

# This script will try to build a barebone toolchain for lm32.
DESTDIR=/opt/cross/lm32-elf

set -ex

# first mkdir so as to ensure that user can write to $DESTDIR
mkdir -p $DESTDIR

## download all source code
#wget -O binutils.tar.bz2 http://ftp.gnu.org/gnu/binutils/binutils-2.23.2.tar.bz2
##wget -O gcc.tar.bz2 http://ftp.gnu.org/gnu/gcc/gcc-4.8.1/gcc-4.8.1.tar.bz2 # xgcc: internal compiler error: Segmentation fault (program cc1) when compiling libgcc/_ffssi2.o
#wget -O gcc.tar.bz2 http://ftp.gnu.org/gnu/gcc/gcc-4.5.3/gcc-core-4.5.3.tar.bz2
#
## gcc pre-requisites
#wget -O gmp.tar.bz2 ftp://gcc.gnu.org/pub/gcc/infrastructure/gmp-4.3.2.tar.bz2
#wget -O mpc.tar.gz ftp://gcc.gnu.org/pub/gcc/infrastructure/mpc-0.8.1.tar.gz
#wget -O mpfr.tar.bz2 ftp://gcc.gnu.org/pub/gcc/infrastructure/mpfr-2.4.2.tar.bz2

rm -rf gcc-src
mkdir -p gcc-src
tar xf gcc.tar.bz2 --strip-components 1 -C gcc-src
# if binutils is newer than gcc, we need binutils' libiberty, not gcc's.
tar xf binutils.tar.bz2 --strip-components 1 -C gcc-src

mkdir gcc-src/gmp
tar xf gmp.tar.bz2 --strip-components 1 -C gcc-src/gmp
mkdir gcc-src/mpfr
tar xf mpfr.tar.bz2 --strip-components 1 -C gcc-src/mpfr
mkdir gcc-src/mpc
tar xf mpc.tar.gz --strip-components 1 -C gcc-src/mpc

mkdir gcc-src/build
cd gcc-src/build

../configure --prefix=$DESTDIR --target=lm32-barebone-elf --with-gnu-as --with-gnu-ld --enable-language=c --disable-threads --disable-shared --disable-multilib --enable-sjlj-exceptions --disable-lto
make
