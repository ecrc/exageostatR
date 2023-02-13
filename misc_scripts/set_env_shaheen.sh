export LC_ALL=en_US.UTF-8
export CRAYPE_LINK_TYPE=dynamic
module switch PrgEnv-cray PrgEnv-gnu
module load intel/18.0.1.163
module unload cray-libsci-nofxt/17.12.1

#module load gsl/2.4
module load cray-netcdf
module load cray-hdf5


#hwloc-1.11.5
export PKG_CONFIG_PATH=/project/k1200/sameh/codes/installation_without_cray-libsci-nofxt/hwloc-1.11.5/hwloc_install/lib/pkgconfig:$PKG_CONFIG_PATH
export LD_LIBRARY_PATH=/project/k1200/sameh/codes/installation_without_cray-libsci-nofxt/hwloc-1.11.5/hwloc_install/lib:$LD_LIBRARY_PATH


export PKG_CONFIG_PATH=/project/k1200/sameh/codes/installation_without_cray-libsci-nofxt/exageostatr/src/hicma/build/install_dir/lib/pkgconfig:/project/k1200/sameh/codes/installation_without_cray-libsci-nofxt/exageostatr/src/hicma/chameleon/build/install_dir/lib/pkgconfig:/project/k1200/sameh/codes/installation_without_cray-libsci-nofxt/exageostatr/src/stars-h/build/install_dir/lib/pkgconfig:/project/k1200/sameh/codes/installation_without_cray-libsci-nofxt/starpu-1.2.5/starpu_install/lib/pkgconfig:/project/k1200/sameh/codes/installation_without_cray-libsci-nofxt/nlopt-2.4.2/nlopt_install/lib/pkgconfig:/project/k1200/sameh/codes/installation_without_cray-libsci-nofxt/gsl-2.4/gsl_install/lib/pkgconfig:$PKG_CONFIG_PATH

export CPATH=/project/k1200/sameh/codes/installation_without_cray-libsci-nofxt/exageostatr/src/hicma/chameleon/build/install_dir/include/coreblas:/project/k1200/sameh/codes/installation_without_cray-libsci-nofxt/starpu-1.2.5/starpu_install/include/:/project/k1200/sameh/codes/installation_without_cray-libsci-nofxt/gsl-2.4/gsl_install/include:$CPATH

export LD_LIBRARY_PATH=/project/k1200/sameh/codes/installation_without_cray-libsci-nofxt/exageostatr/src/hicma/build/install_dir/lib/:/project/k1200/sameh/codes/installation_without_cray-libsci-nofxt/exageostatr/src/hicma/chameleon/build/install_dir/lib/:/project/k1200/sameh/codes/installation_without_cray-libsci-nofxt/exageostatr/src/stars-h/build/install_dir/lib/pkgconfig:/project/k1200/sameh/codes/installation_without_cray-libsci-nofxt/starpu-1.2.5/starpu_install/lib:/project/k1200/sameh/codes/installation_without_cray-libsci-nofxt/nlopt-2.4.2/nlopt_install/lib:$LD_LIBRARY_PATH

export LD_LIBRARY_PATH=/project/k1200/sameh/codes/installation_without_cray-libsci-nofxt/gsl-2.4/gsl_install/lib:$LD_LIBRARY_PATH

export PKG_CONFIG_PATH=/opt/cray/pe/hdf5/1.10.1.1/GNU/5.1/lib/pkgconfig:/opt/cray/pe/netcdf/4.4.1.1.6/GNU/5.1/lib/pkgconfig/:$PKG_CONFIG_PATH
export LD_LIBRARY_PATH=/opt/cray/pe/hdf5/1.10.1.1/GNU/5.1/lib:/opt/cray/pe/netcdf/4.4.1.1.6/GNU/5.1/lib:$LD_LIBRARY_PATH
