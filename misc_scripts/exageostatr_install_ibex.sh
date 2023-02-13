module load intel/2017
#module load gcc/8.1.0
module load gcc/6.4.0
module load cmake/3.9.4/gnu-6.4.0
module load mpich/3.3/gnu-6.4.0
#/intel-2017
module load R/3.5.0/gnu-6.4.0
mkdir -p $R_LIBS
cd ..
cd ..
mkdir installation_dir
cd installation_dir
SETUP_DIR=$PWD

MKLROOT=/sw/csi/intel/2017/compilers_and_libraries/linux/mkl
rm -rf exageostatr
rm -rf $SETUP_DIR/pkg_config.sh
==============================
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
  export LD_LIBRARY_PATH=$NLOPTROOT/nlopt_install/lib:$LD_LIBRARY_PATH

    echo 'export PKG_CONFIG_PATH='$NLOPTROOT'/nlopt_install/lib/pkgconfig:$PKG_CONFIG_PATH' >> $SETUP_DIR/pkg_config.sh
    echo 'export LD_LIBRARY_PATH='$NLOPTROOT'/nlopt_install/lib:$LD_LIBRARY_PATH' >> $SETUP_DIR/pkg_config.sh

================================
cd $SETUP_DIR
if [  ! -d "hwloc-2.0.2" ]; then
        wget https://download.open-mpi.org/release/hwloc/v2.0/hwloc-2.0.2.tar.gz
        tar -zxvf hwloc-2.0.2.tar.gz
fi
cd hwloc-2.0.2
[[ -d hwloc_install ]] || mkdir hwloc_install
CC=gcc ./configure --prefix=$PWD/hwloc_install --disable-libxml2 -disable-pci --enable-shared=yes

make -j
make -j install
HWLOCROOT=$PWD
export PKG_CONFIG_PATH=$HWLOCROOT/hwloc_install/lib/pkgconfig:$PKG_CONFIG_PATH
export LD_LIBRARY_PATH=$HWLOCROOT/hwloc_install/lib:$LD_LIBRARY_PATH
echo 'export PKG_CONFIG_PATH='$HWLOCROOT'/hwloc_install/lib/pkgconfig:$PKG_CONFIG_PATH' >> $SETUP_DIR/pkg_config.sh
echo 'export LD_LIBRARY_PATH='$HWLOCROOT'/hwloc_install/lib:$LD_LIBRARY_PATH' >> $SETUP_DIR/pkg_config.sh
================================
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
export LD_LIBRARY_PATH=$GSLROOT/gsl_install/lib:$LD_LIBRARY_PATH

echo 'export PKG_CONFIG_PATH='$GSLROOT'/gsl_install/lib/pkgconfig:$PKG_CONFIG_PATH' >> $SETUP_DIR/pkg_config.sh
echo 'export LD_LIBRARY_PATH='$GSLROOT'/gsl_install/lib:$LD_LIBRARY_PATH' >> $SETUP_DIR/pkg_config.sh
================================
cd $SETUP_DIR
if [ ! -d "starpu-1.2.5" ]; then
        wget http://starpu.gforge.inria.fr/files/starpu-1.2.5/starpu-1.2.5.tar.gz
        tar -zxvf starpu-1.2.5.tar.gz
fi
cd starpu-1.2.5
[[ -d starpu_install ]] || mkdir starpu_install
CC=gcc  ./configure --prefix=$SETUP_DIR/starpu-1.2.5/starpu_install  -disable-cuda --disable-opencl --with-mpicc=/sw/csis/mpich/3.3/el7.5_gnu6.4.0/bin/mpicc --enable-shared --disable-build-doc --disable-export-dynamic --disable-mpi-check
make -j
make -j  install
STARPUROOT=$PWD
export PKG_CONFIG_PATH=$STARPUROOT/starpu_install/lib/pkgconfig:$PKG_CONFIG_PATH
export LD_LIBRARY_PATH=$STARPUROOT/starpu_install/lib:$LD_LIBRARY_PATH
export CPATH=$STARPUROOT/starpu_install/include/starpu/1.2:$CPATH
echo 'export PKG_CONFIG_PATH='$STARPUROOT'/starpu_install/lib/pkgconfig:$PKG_CONFIG_PATH' >> $SETUP_DIR/pkg_config.sh
echo 'export LD_LIBRARY_PATH='$STARPUROOT'/starpu_install/lib:$LD_LIBRARY_PATH' >> $SETUP_DIR/pkg_config.sh
echo 'export CPATH='$STARPUROOT'/starpu_install/include/starpu/1.2:$CPATH' >> $SETUP_DIR/pkg_config.sh
#************************************************************************ Install Chameleon - Stars-H - HiCMA
cd $SETUP_DIR
# Check if we are already in exageostat repo dir or not.
if git -C $PWD remote -v | grep -q 'https://github.com/ecrc/exageostatr'
then
        # we are, lets go to the top dir (where .git is)
        until test -d $PWD/.git ;
        do
                cd ..
        done;
else
        git clone https://github.com/ecrc/exageostatr
        cd exageostatr
fi
git pull
git submodule update --init --recursive

export EXAGEOSTATDEVDIR=$PWD/src
cd $EXAGEOSTATDEVDIR
export HICMADIR=$EXAGEOSTATDEVDIR/hicma
export CHAMELEONDIR=$EXAGEOSTATDEVDIR/hicma/chameleon
export STARSHDIR=$EXAGEOSTATDEVDIR/stars-h

## STARS-H
cd $STARSHDIR
rm -rf build
mkdir -p build/install_dir


cd build

CC=gcc cmake ..  -DCMAKE_INSTALL_PREFIX=$STARSHDIR/build/install_dir -DMPI=OFF -DOPENMP=OFF -DSTARPU=OFF -DCMAKE_C_FLAGS="-fPIC"

make -j
make install

export PKG_CONFIG_PATH=$STARSHDIR/build/install_dir/lib/pkgconfig:$PKG_CONFIG_PATH
export LD_LIBRARY_PATH=$STARSHDIR/build/install_dir/lib:$LD_LIBRARY_PATH

echo 'export PKG_CONFIG_PATH='$STARSHDIR'/build/install_dir/lib/pkgconfig:$PKG_CONFIG_PATH' >> $SETUP_DIR/pkg_config.sh
echo 'export PKG_CONFIG_PATH='$STARSHDIR'/build/install_dir/lib/pkgconfig:$PKG_CONFIG_PATH' >>  $SETUP_DIR/pkg_config.sh


## CHAMELEON
cd $CHAMELEONDIR
rm -rf build
mkdir -p build/install_dir
cd build


CC=gcc cmake .. -DCMAKE_INSTALL_PREFIX=$PWD/install_dir  -DCMAKE_COLOR_MAKEFILE:BOOL=ON -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON -DBUILD_SHARED_LIBS=ON -DCHAMELEON_ENABLE_EXAMPLE=ON -DCHAMELEON_ENABLE_TESTING=ON -DCHAMELEON_ENABLE_TIMING=ON -DCHAMELEON_USE_MPI=ON -DCHAMELEON_USE_CUDA=OFF -DCHAMELEON_USE_MAGMA=OFF -DCHAMELEON_SCHED_QUARK=OFF -DCHAMELEON_SCHED_STARPU=ON -DCHAMELEON_USE_FXT=OFF -DSTARPU_DIR=$STARPUROOT/starpu_install -DBLAS_LIBRARIES="-L${MKLROOT}/lib;-lmkl_intel_lp64;-lmkl_core;-lmkl_sequential;-lpthread;-lm;-ldl" -DBLAS_COMPILER_FLAGS="-m64;-I${MKLROOT}/include" -DLAPACK_LIBRARIES="-L${MKLROOT}/lib;-lmkl_intel_lp64;-lmkl_core;-lmkl_sequential;-lpthread;-lm;-ldl" -DCBLAS_DIR="${MKLROOT}" -DLAPACKE_DIR="${MKLROOT}" -DTMG_DIR="${MKLROOT}" -DMORSE_VERBOSE_FIND_PACKAGE=ON -DMPI_C_COMPILER=/sw/csis/mpich/3.3/el7.5_gnu6.4.0/bin/mpicc

make -j # CHAMELEON parallel build seems to be fixed
make install

export PKG_CONFIG_PATH=$CHAMELEONDIR/build/install_dir/lib/pkgconfig:$PKG_CONFIG_PATH
export LD_LIBRARY_PATH=$CHAMELEONDIR/build/install_dir/lib:$LD_LIBRARY_PATH
export CPATH=$CHAMELEONDIR/build/install_dir/include/coreblas:$CPATH


echo 'export PKG_CONFIG_PATH='$CHAMELEONDIR'/build/install_dir/lib/pkgconfig:$PKG_CONFIG_PATH'  >>  $SETUP_DIR/pkg_config.sh
echo 'export LD_LIBRARY_PATH='$CHAMELEONDIR'/build/install_dir/lib:$LD_LIBRARY_PATH'  >>  $SETUP_DIR/pkg_config.sh
echo 'export CPATH='$CHAMELEONDIR'/build/install_dir/include/coreblas:$CPATH'  >>  $SETUP_DIR/pkg_config.sh

## HICMA
cd $HICMADIR
rm -rf build
mkdir -p build/install_dir
cd build
===============
CC=gcc cmake ..  -DCMAKE_INSTALL_PREFIX=$PWD/install_dir -DCMAKE_COLOR_MAKEFILE:BOOL=ON -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON -DBUILD_SHARED_LIBS=ON -DHICMA_USE_MPI=ON  -DBLAS_LIBRARIES="-L${MKLROOT}/lib;-lmkl_intel_lp64;-lmkl_core;-lmkl_sequential;-lpthread;-lm;-ldl" -DBLAS_COMPILER_FLAGS="-m64;-I${MKLROOT}/include" -DLAPACK_LIBRARIES="-L${MKLROOT}/lib;-lmkl_intel_lp64;-lmkl_core;-lmkl_sequential;-lpthread;-lm;-ldl" -DCBLAS_DIR="${MKLROOT}" -DLAPACKE_DIR="${MKLROOT}" -DTMG_DIR="${MKLROOT}" -DMORSE_VERBOSE_FIND_PACKAGE=ON -DMPI_C_COMPILER=/sw/csis/mpich/3.3/el7.5_gnu6.4.0/bin/mpicc
make -j
make install

export PKG_CONFIG_PATH=$HICMADIR/build/install_dir/lib/pkgconfig:$PKG_CONFIG_PATH
export LD_LIBRARY_PATH=$HICMADIR/build/install_dir/lib:$LD_LIBRARY_PATH


echo 'export PKG_CONFIG_PATH='$HICMADIR'/build/install_dir/lib/pkgconfig:$PKG_CONFIG_PATH' >>  $SETUP_DIR/pkg_config.sh
echo 'export LD_LIBRARY_PATH='$HICMADIR'/build/install_dir/lib:$LD_LIBRARY_PATH' >>  $SETUP_DIR/pkg_config.sh

cd $SETUP_DIR
#R CMD build exageostatr
#R CMD INSTALL exageostat_1.0.0.tar.gz
export LD_PRELOAD=$MKLROOT/lib/intel64/libmkl_core.so:$MKLROOT/lib/intel64/libmkl_sequential.so

echo 'module load intel/2017' >> $SETUP_DIR/pkg_config.sh
echo 'module load gcc/6.4.0' >> $SETUP_DIR/pkg_config.sh
echo 'module load cmake/3.9.4/gnu-6.4.0' >> $SETUP_DIR/pkg_config.sh
echo 'module load mpich/3.3/gnu-6.4.0' >> $SETUP_DIR/pkg_config.sh
echo 'module load R/3.5.0/gnu-6.4.0' >> $SETUP_DIR/pkg_config.sh
echo 'export LD_PRELOAD=$MKLROOT/lib/intel64/libmkl_core.so:$MKLROOT/lib/intel64/libmkl_sequential.so' >>  $SETUP_DIR/pkg_config.sh
