pipeline {
/*
 * Defining where to run
 */
//// Any:
// agent any
//// By agent label:
//    agent { label 'sandybridge' }

    agent { label 'jenkinsfile' }
    triggers {
        pollSCM('H/15 * * * *')
    }
    environment {
        XX="gcc"
    }

    options {
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '50'))
        timestamps()
    }

    stages {
        stage ('build') {

            steps {
		    withCredentials([string(credentialsId: '549fe118-9b01-49f6-9072-a813312a022b', variable: 'GITHUB_PAT')]) {

            	sh '''#!/bin/bash -le
		module purge
        module load ecrc-extras
        module load mkl/2020.0.166
        module load gcc/10.2.0
        module load cmake/3.21.2
        module load hwloc/2.4.0-gcc-10.2.0
        module load openmpi/4.1.0-gcc-10.2.0
        module load starpu/1.3.9-gcc-10.2.0-mkl-openmpi-4.1.0
        module load gsl/2.6-gcc-10.2.0
        module load nlopt/2.7.0-gcc-10.2.0
        module load hdf5/1.12.0-gcc-10.2.0
        module load netcdf/4.7.4-gcc-10.2.0
        module load r-base/4.1.2-gcc-10.2.0

        module list
        set -x

        #export the shared R libraries path
        export R_LIBS=/opt/ecrc/r-base/4.1.2-gcc-10.2.0/ub18/libraries
        export LD_PRELOAD=/opt/ecrc/mkl/2020.0.166/mkl/lib/intel64/libmkl_def.so:/opt/ecrc/mkl/2020.0.166/mkl/lib/intel64/libmkl_avx2.so:/opt/ecrc/mkl/2020.0.166/mkl/lib/intel64/libmkl_core.so:/opt/ecrc/mkl/2020.0.166/mkl/lib/intel64/libmkl_intel_lp64.so:/opt/ecrc/mkl/2020.0.166/mkl/lib/intel64/libmkl_intel_thread.so:/opt/ecrc/intelmpi/2020.0.166/lib/intel64/libiomp5.so

        #Try to build in parallel
		export MAKE='make -j 6 -l 8'
		git submodule update --recursive --init

        export EXAGEOSTATR=$PWD
		##### BUILDING EXAGEOSTAT-R DEPENDENCIES #####
		    export EXAGEOSTATDEVDIR=$PWD/src
            export HICMADIR=$EXAGEOSTATDEVDIR/hicma
            export CHAMELEONDIR=$EXAGEOSTATDEVDIR/chameleon
            export STARSHDIR=$HICMADIR/stars-h
            export HCOREDIR=$HICMADIR/hcore
            export HICMAINSTALLDIR=$HICMADIR/dependencies-prefix

            cd $EXAGEOSTATDEVDIR
            # Update submodules
            git submodule update --init --recursive
            ls

            ## CHAMELEON
            cd $CHAMELEONDIR
            git checkout release-1.1.0

            #install Chameleon
            rm -rf build
            mkdir -p build/installdir
            cd build
            cmake .. -DCMAKE_INSTALL_PREFIX=$PWD/installdir -DCMAKE_C_FLAGS=-fPIC -DCHAMELEON_USE_MPI=OFF -DCMAKE_BUILD_TYPE="Release" \
            -DCMAKE_C_FLAGS_RELEASE="-O3 -Ofast -w" -DCHAMELEON_USE_CUDA=OFF -DCHAMELEON_ENABLE_EXAMPLE=OFF \
            -DCHAMELEON_ENABLE_TESTING=OFF -DCHAMELEON_ENABLE_TIMING=OFF -DBUILD_SHARED_LIBS=OFF

            make clean
            make -j # CHAMELEON parallel build seems to be fixed
            make install
            export PKG_CONFIG_PATH=$PWD/installdir/lib/pkgconfig:$PKG_CONFIG_PATH

            ## HICMA
            cd $HICMADIR
            git submodule update --init --recursive
            mkdir -p $HICMAINSTALLDIR
            rm -rf $HICMAINSTALLDIR/*

                # STARS-H
                cd $STARSHDIR
                rm -rf build
                mkdir -p build
                cd build
                cmake .. -DCMAKE_INSTALL_PREFIX=$HICMAINSTALLDIR -DMPI=OFF -DOPENMP=OFF -DSTARPU=OFF -DBUILD_SHARED_LIBS=ON -DCMAKE_C_FLAGS=-fPIC -DCMAKE_C_FLAGS_RELEASE="-O3 -Ofast -w"
                make clean
                make -j
                make install

                ## HCORE
                cd $HCOREDIR
                rm -rf build
                mkdir -p build
                cd build
                cmake .. -DCMAKE_INSTALL_PREFIX=$HICMAINSTALLDIR -DCMAKE_C_FLAGS=-fPIC -DBUILD_SHARED_LIBS=ON -DCMAKE_C_FLAGS_RELEASE="-O3 -Ofast -w"
                make clean
                make -j
                make install

            export PKG_CONFIG_PATH=$HICMAINSTALLDIR/lib/pkgconfig:$PKG_CONFIG_PATH
            cd $HICMADIR
            rm -rf build
            mkdir -p build/installdir
            cd build
            cmake .. -DCMAKE_INSTALL_PREFIX=$PWD/installdir -DCMAKE_C_FLAGS=-fPIC -DHICMA_USE_MPI="$MPI_VALUE" -DCMAKE_BUILD_TYPE="Release" \
            -DCMAKE_C_FLAGS_RELEASE="-O3 -Ofast -w" -DBUILD_SHARED_LIBS=ON -DCMAKE_C_FLAGS="-fcommon"
            make clean
            make -j
            make install
            export PKG_CONFIG_PATH=$PWD/installdir/lib/pkgconfig:$PKG_CONFIG_PATH

        ##### BUILDING EXAGEOSTAT-R ######
        cd $EXAGEOSTATR
        mkdir R_LIB
        R CMD build .
        package=$(ls -rt exa*z | tail -n 1)
        R CMD INSTALL ./$package --library=$PWD/R_LIB/

        R CMD check . --no-manual
		'''
                
            }
		      }
        }
    }

    // Post build actions
    post {
        //always {
        //}
        //success {
        //}
        //unstable {
        //}
        //failure {
        //}
        unstable {
                emailext body: "${env.JOB_NAME} - Please go to ${env.BUILD_URL}", subject: "Jenkins Pipeline build is UNSTABLE", recipientProviders: [[$class: 'CulpritsRecipientProvider'], [$class: 'RequesterRecipientProvider']]
        }
        failure {
                emailext body: "${env.JOB_NAME} - Please go to ${env.BUILD_URL}", subject: "Jenkins Pipeline build FAILED", recipientProviders: [[$class: 'CulpritsRecipientProvider'], [$class: 'RequesterRecipientProvider']]
        }
    }
}

