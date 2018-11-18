#!/bin/bash -x


# variables
BASEDIR=$PWD
SETUP_DIR=""
TMPDIR=/tmp/_$$

mkdir -p $TMPDIR

SETUP_DIR=$1
if [ -z "$SETUP_DIR" ]; then
# Use RLIBS for setup dir
arr=(`Rscript -e '.libPaths()' | gawk '{printf "%s ",$2}'`)
for i in ${!arr[*]};
do
    dir=`echo ${arr[$i]}|tr -d \"`
    if [ -d "$dir" ] && [ -w "$dir" ]
    then
        SETUP_DIR="$dir/exageostat"
        break
    fi
done
fi
mkdir -p $SETUP_DIR

if [ -z "$SETUP_DIR" ]
then
    echo "Check your .libPaths() in R. Could not find a writable directory."
    exit 1;
fi

if [ -n "$MKLROOT" ] && [ -d "$MKLROOT" ]; then
    echo "mkl_dir directory exists!"
    echo "Great... continue set-up"
else
    echo "MKLROOT Directory does not exist!... Please define and export MKLROOT variable"
    exit 1
fi
PREFIX=$SETUP_DIR


echo 'The installation directory is '$SETUP_DIR
echo 'The mkl root directory is '$MKLROOT

############################## Check OS
echo "Finding the current os type"
echo
osType=$(uname)
case "$osType" in 
	"Darwin")
	{
	  echo "Running on Mac OSX."
	  CURRENT_OS="OSX"
	} ;;    
	"Linux")
	{
	  echo "Running on LINUX."
	  CURRENT_OS="LINUX"
	} ;;
       *) 
       {
         echo "Unsupported OS, exiting"
         exit
       } ;;

esac

#################################################
export MKLROOT=$MKLROOT
. $MKLROOT/bin/mklvars.sh intel64



export PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH
rpaths="-Wl,-rpath=$PREFIX/lib -Wl,-rpath=$PREFIX/libs -L$PREFIX/lib "
echo "LDFLAGS += $rpaths " >> src/Makefile

#*****************************************************************************
set -e

if [ $CURRENT_OS == "LINUX" ]
then
    export LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH
else
    export DYLD_LIBRARY_PATH=$PREFIX/lib:$DYLD_LIBRARY_PATH
fi

#*****************************************************************************install Nlopt
if ! pkg-config --exists --atleast-version=2.4 nlopt
then
    cd $TMPDIR
    wget http://ab-initio.mit.edu/nlopt/nlopt-2.4.2.tar.gz -O - | tar -zx
    cd nlopt-2.4.2
    ./configure --enable-shared --without-guile --prefix=$PREFIX
    make -j || make && make install
fi

#*****************************************************************************install gsl
if ! pkg-config --exists --atleast-version=2 gsl
then
    cd $TMPDIR
    wget https://ftp.gnu.org/gnu/gsl/gsl-2.4.tar.gz -O - | tar -zx
    cd gsl-2.4
    ./configure --prefix=$PREFIX
    make -j || make && make install
fi
#*****************************************************************************install hwloc
if ! pkg-config --exists --atleast-version=1.11 hwloc
then
    cd $TMPDIR
    wget https://www.open-mpi.org/software/hwloc/v1.11/downloads/hwloc-1.11.5.tar.gz -O - | tar -zx
    cd hwloc-1.11.5
    ./configure --prefix=$PREFIX
    make -j || make && make install
fi
#*****************************************************************************install Starpu
if ! pkg-config --exists --atleast-version=1.2 libstarpu
then
    cd $TMPDIR
    wget http://starpu.gforge.inria.fr/files/starpu-1.2.5/starpu-1.2.5.tar.gz
    tar -zxvf starpu-1.2.5.tar.gz
    cd starpu-1.2.5
    ./configure --disable-cuda --disable-opencl --prefix=$PREFIX
    make -j || make && make install
fi
#************************************************************************ Install Chameleon - Stars-H - HiCMA 
#cd $TMPDIR && rm -rf $TMPDIR/exageostatR
#git clone https://github.com/ecrc/exageostatR.git
#cd exageostatR
## I guess we have everything already
cd $BASEDIR
git submodule update --init --recursive || true
cd src
cd hicma
cd chameleon
mkdir -p build && cd build
cmake .. -DCHAMELEON_USE_MPI=OFF -DCHAMELEON_ENABLE_EXAMPLE=OFF -DCHAMELEON_ENABLE_TESTING=OFF -DCHAMELEON_ENABLE_TIMING=OFF -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=$PREFIX
make -j 20 || make VERBOSE=1 && make install
#cd $TMPDIR
cd $BASEDIR && cd src
cd stars-h
mkdir -p build && cd build
cmake .. -DCMAKE_C_FLAGS=-fPIC -DEXAMPLES=OFF -DTESTING=OFF -DMPI=OFF -DCMAKE_INSTALL_PREFIX=$PREFIX
make -j 20 || make VERBOSE=1 && make install
#cd $TMPDIR
cd $BASEDIR && cd src
cd hicma
mkdir -p build && cd build
cmake .. -DBUILD_SHARED_LIBS=ON -DHICMA_ENABLE_TESTING=OFF -DHICMA_ENABLE_TIMING=OFF -DCMAKE_INSTALL_PREFIX=$PREFIX
make -j 20 || make VERBOSE=1 && make install
#cd $TMPDIR
#cd exageostatR && cd src
#mkdir -p build && cd build
#export CPATH=$CPATH:$TMPDIR/exageostatR/src/hicma/chameleon/coreblas/include/coreblas
#cmake ..
#make -j >/dev/null 2>&1 || make VERBOSE=1
#make install

rm -rf $TMPDIR

