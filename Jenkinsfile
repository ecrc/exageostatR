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
        stage ('build-from-github') {
            steps {
                withCredentials([string(credentialsId: '549fe118-9b01-49f6-9072-a813312a022b', variable: 'GITHUB_PAT')]) {
                    sh '''#!/bin/bash -le
module purge
module load ecrc-extras
module load mkl/2018-update-1
module load gcc/5.5.0
module load pcre
module load r-base/3.5.1-mkl

module list
set -x

export MAKE='make -j 6 -l 8' # try to build in parallel

_REPO=`git config --get remote.origin.url | cut -d "/" -f 4,5,6| sed 's/\\.git$//'`
Rscript -e "Sys.setenv(PKG_CONFIG_PATH=paste(Sys.getenv('PKG_CONFIG_PATH'),paste(.libPaths(),'exageostat/lib/pkgconfig',sep='/',collapse=':'),sep=':')); library(devtools); install_github(repo='$_REPO',ref='$BRANCH_NAME',auth_token='$GITHUB_PAT',quiet=FALSE);"

Rscript tests/test1.R
'''
                }
            }
        }
        stage ('build-locally') {
            steps {
                sh '''#!/bin/bash -le
module purge
module load ecrc-extras
module load mkl/2018-update-1
module load gcc/5.5.0
module load pcre
module load r-base/3.5.1-mkl
#module load gsl/2.4-gcc-5.5.0
#module load nlopt/2.4.2-gcc-5.5.0
#module load hwloc/1.11.8-gcc-5.5.0
#module load starpu/1.2.6-gcc-5.5.0-mkl-openmpi-3.0.0


module list
set -x

export MAKE='make -j 6 -l 8' # try to build in parallel

# export PKG_CONFIG_PATH 
$(Rscript -e '.libPaths()' | gawk -v pkgp="$PKG_CONFIG_PATH" 'BEGIN {printf "export PKG_CONFIG_PATH=%s:",pkgp}; {printf "%s/exageostat/lib/pkgconfig:",substr($2,2,length($2)-2)};')

R CMD build .
package=$(ls -rt exa*z | tail -n 1)
R CMD INSTALL ./$package
Rscript tests/test1.R

'''
            }
        }
        stage ('build-gpu') {
            agent { label 'jenkinsfile-gpu' }
            steps {
                sh '''#!/bin/bash -le
module purge
module load ecrc-extras
module load mkl/2018-update-1
module load gcc/5.5.0
module load pcre
module load r-base/3.5.1-mkl
module load cuda/10.0


module list
set -x

export MAKE='make -j 6 -l 8' # try to build in parallel

# export PKG_CONFIG_PATH
$(Rscript -e '.libPaths()' | gawk -v pkgp="$PKG_CONFIG_PATH" 'BEGIN {printf "export PKG_CONFIG_PATH=%s:",pkgp}; {printf "%s/exageostat/lib/pkgconfig:",substr($2,2,length($2)-2)};')

R CMD build .
package=$(ls -rt exa*z | tail -n 1)
R CMD INSTALL --configure-args='--enable-cuda' ./$package
Rscript tests/test1.R

'''
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

