#
#
# Copyright (c) 2017-2020 King Abdullah University of Science and Technology
# All rights reserved.
#
# ExaGeoStat-R is a software package provided by KAUST
#
#
#
# @file exageostat_test_wrapper.R
# ExaGeoStat R wrapper functions
#
# @version 1.0.1
#
# @author Sameh Abdulah
# @date 2019-09-25

library(assertthat)


#' Initial an instance of ExaGeoStatR
#' @param hardware A list of ncores, ngpus, tile size, pgrid, and qgrid
#' @return N/A
#' @examples
#' exageostat_init(hardware = list(ncores = 2, ngpus = 0, ts = 320, lts = 0, pgrid = 1, qgrid = 1))
#' exageostat_init(hardware = list(ncores = 1, ngpus = 2, ts = 320, lts = 0, pgrid = 1, qgrid = 1))
#' exageostat_init(hardware = list(ncores = 26, ngpus = 0, ts = 320, lts = 0, pgrid = 3, qgrid = 4))
exageostat_init <-
  function(hardware = list(ncores = 2, ngpus = 0, ts = 320, lts = 0, pgrid = 1, qgrid = 1)) {
    ncores <<- hardware$ncores
    ngpus <<- hardware$ngpus
    dts <<- hardware$ts
    lts <<- hardware$lts
    pgrid <<- hardware$pgrid
    qgrid <<- hardware$qgrid
    #library(parallel)
    #        library(foreach)
    #        library(doParallel)
    #       machineVec <- c(rep("nid00816",4), rep("nid00817",4), rep("nid00818",4), rep("nid00819",4))
    #       c1<<-makeCluster(machineVec, port=22222)
    #        registerDoParallel(c1)
    #        getDoParWorkers()
    #       x = detectCores()
    #       print(x)
    Sys.setenv(OMP_NUM_THREADS = 1)
    #Sys.setenv(STARPU_WORKERS_NOBIND = 1)
    Sys.setenv(STARPU_CALIBRATE = 1)
    #Sys.setenv(STARPU_SCHED = "eager")
    Sys.setenv(STARPU_SILENT = 1) 
    Sys.setenv(KMP_AFFINITY = "disabled")   
    #mcaffinity(1:hardware$ncores)
    
    .C("rexageostat_init",
       as.integer(ncores),
       as.integer(ngpus),
       as.integer(dts))
    print("back from exageostat_init C function call. Hit key....")
  }

exageostat_finalize <- function()
{
  .C("rexageostat_finalize")
  print("back from exageostat_finalize C function call. Hit key....")
}
