#!/bin/bash
#At least one argument should be passed to the script
if [ $# -le 0 ]; then
	echo "At least one argument should be provided to the script as the first arg (i.e., install-cpu INSTALLATION_DIR)\n"     
	exit 1
fi

# variables
SETUP_DIR=""


# Use RLIBS for setup dir
arr=(`Rscript -e '.libPaths()' | gawk '{printf "%s ",$2}'`)
for ix in ${!arr[*]};
do
    if [ -d "${arr[$ix]}" ] && [ -w "${arr[$ix]}" ]
    then
        SETUP_DIR="${arr[$ix]}/exageostat"
    fi
done
if [ $SETUP_DIR == "" ]
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

#*****************************************************************************

#*****************************************************************************install Nlopt
cd $SETUP_DIR
if [ ! -d "nlopt-2.4.2" ]; then
        wget http://ab-initio.mit.edu/nlopt/nlopt-2.4.2.tar.gz
        tar -zxvf nlopt-2.4.2.tar.gz
fi
cd nlopt-2.4.2
[[ -d nlopt_install ]] || mkdir nlopt_install
CC=gcc ./configure --prefix=$PWD/nlopt_install/ --enable-shared --without-guile
make -j
make -j install
NLOPTROOT=$PWD
export PKG_CONFIG_PATH=$NLOPTROOT/nlopt_install/lib/pkgconfig:$PKG_CONFIG_PATH

if [ $CURRENT_OS == "LINUX" ]
then
	export LD_LIBRARY_PATH=$NLOPTROOT/nlopt_install/lib:$LD_LIBRARY_PATH
else
        export DYLD_LIBRARY_PATH=$NLOPTROOT/nlopt_install/lib:$DYLD_LIBRARY_PATH
fi
#*****************************************************************************install gsl
cd $SETUP_DIR
if [ ! -d "gsl-2.4" ]; then
        wget https://ftp.gnu.org/gnu/gsl/gsl-2.4.tar.gz
        tar -zxvf gsl-2.4.tar.gz
fi
cd gsl-2.4
[[ -d gsl_install ]] || mkdir gsl_install
CC=gcc ./configure --prefix=$PWD/gsl_install/
make -j
make -j install
GSLROOT=$PWD
export PKG_CONFIG_PATH=$GSLROOT/gsl_install/lib/pkgconfig:$PKG_CONFIG_PATH
if [ $CURRENT_OS == "LINUX" ]
then
	export LD_LIBRARY_PATH=$GSLROOT/gsl_install/lib:$LD_LIBRARY_PATH
else
        export DYLD_LIBRARY_PATH=$GSLROOT/gsl_install/lib:$DYLD_LIBRARY_PATH
fi

#*****************************************************************************install hwloc
cd $SETUP_DIR
if [  ! -d "hwloc-1.11.5" ]; then
        wget https://www.open-mpi.org/software/hwloc/v1.11/downloads/hwloc-1.11.5.tar.gz
        tar -zxvf hwloc-1.11.5.tar.gz
fi
cd hwloc-1.11.5
[[ -d hwloc_install ]] || mkdir hwloc_install
CC=gcc ./configure --prefix=$SETUP_DIR/hwloc-1.11.5/hwloc_install 
make -j
make -j install
HWLOCROOT=$PWD
export PKG_CONFIG_PATH=$HWLOCROOT/hwloc_install/lib/pkgconfig:$PKG_CONFIG_PATH
if [ $CURRENT_OS == "LINUX" ]
then
	export LD_LIBRARY_PATH=$HWLOCROOT/hwloc_install/lib:$LD_LIBRARY_PATH
else
        export DYLD_LIBRARY_PATH=$HWLOCROOT/hwloc_install/lib:$DYLD_LIBRARY_PATH
fi	
#*****************************************************************************install Starpu
cd $SETUP_DIR
if [ ! -d "starpu-1.2.1" ]; then
        wget http://starpu.gforge.inria.fr/files/starpu-1.2.1/starpu-1.2.1.tar.gz
        tar -zxvf starpu-1.2.1.tar.gz
fi
cd starpu-1.2.1
[[ -d starpu_install ]] || mkdir starpu_install
 ./configure --prefix=$SETUP_DIR/starpu-1.2.1/starpu_install  -disable-cuda -disable-mpi --disable-opencl
make -j
make -j  install
STARPUROOT=$PWD
export PKG_CONFIG_PATH=$STARPUROOT/starpu_install/lib/pkgconfig:$PKG_CONFIG_PATH

if [ $CURRENT_OS == "LINUX" ]
then
	export LD_LIBRARY_PATH=$STARPUROOT/starpu_install/lib:$LD_LIBRARY_PATH
else
        export DYLD_LIBRARY_PATH=$STARPUROOT/starpu_install/lib:$DYLD_LIBRARY_PATH
fi
#************************************************************************ Install Chameleon - Stars-H - HiCMA 
cd $SETUP_DIR
# Check if we are already in exageostat repo dir or not.
if git -C $PWD remote -v | grep -q 'https://github.com/ecrc/exageostat-dev'
then
        # we are, lets go to the top dir (where .git is)
        until test -d $PWD/.git ;
        do
                cd ..
        done;
else
        git clone https://github.com/ecrc/exageostat-dev
        cd exageostat-dev
fi
git submodule init
git submodule update
EXAGEOSTATROOT=$PWD

cd hicma-dev
HICMAROOT=$PWD
git submodule init
git submodule update
############################# Chameleon Installation
cd chameleon
CHAMELEONROOT=$PWD
git submodule init
git submodule update
mkdir -p build/installdir
cd build
CC=gcc cmake .. -DCMAKE_BUILD_TYPE=Debug -DCHAMELEON_USE_MPI=OFF -DCMAKE_INSTALL_PREFIX=$PWD/installdir -DBUILD_SHARED_LIBS=ON
make -j
make install
export PKG_CONFIG_PATH=$CHAMELEONROOT/build/installdir/lib/pkgconfig:$PKG_CONFIG_PATH
if [ $CURRENT_OS == "LINUX" ]
then
        export LD_LIBRARY_PATH=$CHAMELEONROOT/build/installdir/lib:$LD_LIBRARY_PATH
else
        export DYLD_LIBRARY_PATH=$CHAMELEONROOT/build/installdir/lib:$DYLD_LIBRARY_PATH
fi
############################# Stars-H Installation
cd $EXAGEOSTATROOT
cd stars-h-dev
git submodule init
git submodule update
STARSHROOT=$PWD
mkdir -p build/installdir
cd build
CC=gcc cmake .. -DCMAKE_INSTALL_PREFIX=$PWD/installdir/ -DCMAKE_C_FLAGS=-fPIC
make -j
make install
export PKG_CONFIG_PATH=$STARSHROOT/build/installdir/lib/pkgconfig:$PKG_CONFIG_PATH
if [ $CURRENT_OS == "LINUX" ]
then
        export LD_LIBRARY_PATH=$STARSHROOT/build/installdir/lib:$LD_LIBRARY_PATH
else
        export DYLD_LIBRARY_PATH=$STARSHROOT/build/installdir/lib:$DYLD_LIBRARY_PATH
fi
############################# HiCMA Installation
cd $HICMAROOT
mkdir -p build/installdir
cd build
CC=gcc cmake .. -DCMAKE_INSTALL_PREFIX=$PWD/installdir -DHICMA_USE_MPI=OFF -DCMAKE_C_FLAGS=-fPIC
make -j
make install
export PKG_CONFIG_PATH=$HICMAROOT/build/installdir/lib/pkgconfig:$PKG_CONFIG_PATH
if [ $CURRENT_OS == "LINUX" ]
then
        export LD_LIBRARY_PATH=$HICMAROOT/build/installdir/lib:$LD_LIBRARY_PATH
else
        export DYLD_LIBRARY_PATH=$HICMAROOT/build/installdir/lib:$DYLD_LIBRARY_PATH
fi
##################################################################################



