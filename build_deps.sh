#!/bin/bash
#At least one argument should be passed to the script
if [ $# -le 0 ]; then
	echo "At least one argument should be provided to the script as the first arg (i.e., install-cpu INSTALLATION_DIR)\n"     
	exit 1
fi

SETUP_DIR=$1

if [ $# -le 1 ]; then
	MKL_DIR=/opt/intel/mkl
        echo "The default MKL path is used (MKL_DIR=/opt/intel/mkl)\n"
else
    MKL_DIR=$2
fi

if [ -d "$MKL_DIR" ]; then
        echo "mkl_dir directory exists!"
        echo "Great... continue set-up"
else
        echo "MKL Directory does not exist!... Please provide it to the installation file as a second arg (i.e., install-cpu.sh INSTALLATION_DIR  MKL_INSTALLATION_DIR)"
        echo $MKL_DIR
        exit 1
fi

echo 'The installation directory is '$SETUP_DIR
echo 'The mkl root directory is '$MKL_DIR
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
export MKLROOT=$MKL_DIR
. $MKLROOT/bin/mklvars.sh intel64

#***************************************************************************** clean bashrc from previous installation
sed -i '/## EXAGEOSTAT-INSTALLATION-BEGIN/,/## EXAGEOSTAT-INSTALLATION-END/d'  ~/.bashrc

#*****************************************************************************


#*****************************************************************************download exageostat
#if git -C $PWD remote -v | grep -q 'https://github.com/ecrc/exageostat-dev'
#then
    # we are, lets go to the top dir (where .git is)
#    until test -d $PWD/.git ;
#    do
#        cd ..
#    done;
#else
    #we are not, we need to clone the repo
#    git clone -b sabdulah/refine-docs  https://github.com/ecrc/exageostat-dev.git
#    cd exageostat-dev
#fi
#export EXAGEOSTATDEVDIR=$PWD
#[[ -d dependencies ]] || mkdir dependencies
#cd dependencies
#SETUP_DIR=$PWD
#echo 'export EXAGEOSTATDEVDIR='$PWD >> ~/.bashrc
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

#*****************************************************************************install cmake
#cd $SETUP_DIR
#if [  ! -d "cmake-3.10.0-rc3" ]; then
#        wget https://cmake.org/files/v3.10/cmake-3.10.0-rc3.tar.gz
#        tar -zxvf cmake-3.10.0-rc3.tar.gz
#fi
#cd cmake-3.10.0-rc3
#[[ -d cmake_install ]] || mkdir cmake_install
#CC=gcc ./configure --prefix=$SETUP_DIR/cmake-3.10.0-rc3/cmake_install
#make -j
#make -j install
#CMAKEROOT=$PWD
#export PATH=$PWD/cmake_install/bin/:$PATH
#echo 'export PATH='$PWD'/cmake_install/bin/:$PATH' >> ~/.bashrc
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
#*****************************************************************************install chameleon
cd $SETUP_DIR
# Check if we are already in exageostat repo dir or not.
if git -C $PWD remote -v | grep -q 'https://gitlab.inria.fr/solverstack/chameleon.git'
then
        # we are, lets go to the top dir (where .git is)
        until test -d $PWD/.git ;
        do
                cd ..
        done;
else
        git clone https://gitlab.inria.fr/solverstack/chameleon.git
        cd chameleon
fi
git submodule init
git submodule update
mkdir -p build/installdir
cd build
CC=gcc cmake .. -DCMAKE_BUILD_TYPE=Debug -DCHAMELEON_USE_MPI=OFF -DCMAKE_INSTALL_PREFIX=$PWD/installdir -DBUILD_SHARED_LIBS=ON
make
make install
CHAMELEONROOT=$PWD
export PKG_CONFIG_PATH=$CHAMELEONROOT/installdir/lib/pkgconfig:$PKG_CONFIG_PATH
if [ $CURRENT_OS == "LINUX" ]
then
	export LD_LIBRARY_PATH=$CHAMELEONROOT/installdir/lib:$LD_LIBRARY_PATH
else
        export DYLD_LIBRARY_PATH=$CHAMELEONROOT/installdir/lib:$DYLD_LIBRARY_PATH
fi
#***************************************************************************** edit bashrc file
echo '## EXAGEOSTAT-INSTALLATION-BEGIN' >> ~/.bashrc
#*****************************************************************************source intel MKL
#MKL
echo '. '$MKLROOT'/bin/mklvars.sh intel64' >> ~/.bashrc
echo 'export MKLROOT='$MKL_DIR >> ~/.bashrc
echo 'export LD_PRELOAD='$MKL_DIR'/lib/intel64/libmkl_core.so:'$MKL_DIR'/lib/intel64/libmkl_sequential.so' >> ~/.bashrc

#NLOPT
echo 'export PKG_CONFIG_PATH='$NLOPTROOT'/nlopt_install/lib/pkgconfig:$PKG_CONFIG_PATH' >> ~/.bashrc
if [ $CURRENT_OS == "LINUX" ]
then
	echo 'export LD_LIBRARY_PATH='$NLOPTROOT'/nlopt_install/lib:$LD_LIBRARY_PATH' >> ~/.bashrc
else
        echo 'export DYLD_LIBRARY_PATH='$NLOPTROOT'/nlopt_install/lib:$DYLD_LIBRARY_PATH' >> ~/.bashrc
fi
#GSL
echo 'export PKG_CONFIG_PATH='$GSLROOT'/gsl_install/lib/pkgconfig:$PKG_CONFIG_PATH' >> ~/.bashrc
if [ $CURRENT_OS == "LINUX" ]
then
	echo 'export LD_LIBRARY_PATH='$GSLROOT'/gsl_install/lib:$LD_LIBRARY_PATH' >> ~/.bashrc
else
        echo 'export DYLD_LIBRARY_PATH='$GSLROOT'/gsl_install/lib:$DYLD_LIBRARY_PATH' >> ~/.bashrc
fi
#hwloc
echo 'export PKG_CONFIG_PATH='$HWLOCROOT'/hwloc_install/lib/pkgconfig:$PKG_CONFIG_PATH' >> ~/.bashrc
if [ $CURRENT_OS == "LINUX" ]
then
	echo 'export LD_LIBRARY_PATH='$HWLOCROOT'/hwloc_install/lib:$LD_LIBRARY_PATH' >> ~/.bashrc
else
        echo 'export DYLD_LIBRARY_PATH='$HWLOCROOT'/hwloc_install/lib:$DYLD_LIBRARY_PATH' >> ~/.bashrc	
fi
#starpu
echo 'export PKG_CONFIG_PATH='$STARPUROOT'/starpu_install/lib/pkgconfig:$PKG_CONFIG_PATH' >> ~/.bashrc
if [ $CURRENT_OS == "LINUX" ]
then
	echo 'export LD_LIBRARY_PATH='$STARPUROOT'/starpu_install/lib:$LD_LIBRARY_PATH' >> ~/.bashrc
else
        echo 'export DYLD_LIBRARY_PATH='$STARPUROOT'/starpu_install/lib:$DYLD_LIBRARY_PATH' >> ~/.bashrc
fi
#CHAMELEON
echo 'export PKG_CONFIG_PATH='$CHAMELEONROOT'/installdir/lib/pkgconfig:$PKG_CONFIG_PATH' >> ~/.bashrc
if [ $CURRENT_OS == "LINUX" ]
then
	echo 'export LD_LIBRARY_PATH='$CHAMELEONROOT'/installdir/lib:$LD_LIBRARY_PATH' >> ~/.bashrc
else
        echo 'export DYLD_LIBRARY_PATH='$CHAMELEONROOT'/installdir/lib:$DYLD_LIBRARY_PATH' >> ~/.bashrc	
fi
#end
echo '## EXAGEOSTAT-INSTALLATION-END' >> ~/.bashrc
##################################################################################
#cd $EXAGEOSTATDEVDIR
#rm -rf build
#mkdir -p build
#cd build
#cmake .. \
#    -DCMAKE_INSTALL_PREFIX=$PWD/installdir \
#    -DEXAGEOSTAT_SCHED_STARPU=ON \
#    -DEXAGEOSTAT_USE_MPI=OFF \
#    -DEXAGEOSTAT_PACKAGE=ON \
#    -DCMAKE_BUILD_TYPE=Release \

#on Shaheen
#cmake ..  -DCMAKE_CXX_COMPILER=CC -DCMAKE_C_COMPILER=cc -DCMAKE_Fortran_COMPILER=ftn    -DCMAKE_INSTALL_PREFIX=$PWD/installdir     -DEXAGEOSTAT_SCHED_STARPU=ON     -DEXAGEOSTAT_USE_MPI=ON     -DEXAGEOSTAT_PACKAGE=ON -DMPI_C_LIBRARIES=/opt/cray/mpt/7.2.6/gni/mpich-intel/14.0/lib -DMPI_C_INCLUDE_PATH=/opt/cray/mpt/7.2.6/gni/mpich-intel/14.0/include/

#make clean
#make -j || make VERBOSE=1
#make install
##########################################################################################
#STARPU_SILENT=1  numactl --interleave=all ./examples/zgen_mle_test --test --N=1600 --ts=960 --ncores=35  --computation=exact  --kernel=?:?:? --ikernel=1:0.1:0.5  --olb=0.01:0.01:0.01  --oub=5:5:5 --zvecs=1 --predict=50 



