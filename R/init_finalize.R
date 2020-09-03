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
	  
    if(exists("active_instance") && active_instance == 1)
    {
        print("There is already an active instance... Hit key....")
        return(NULL)
    }
    ncores <<- hardware$ncores
    ngpus <<- hardware$ngpus
    dts <<- hardware$ts
    lts <<- hardware$lts
    pgrid <<- hardware$pgrid
    qgrid <<- hardware$qgrid
    active_instance <<- 1

    #assert_that(ncores >= 0)
    #assert_that(ngpus >= 0)
    #assert_that(dts > 0)
    #assert_that(lts >= 0)
    #assert_that(pgrid > 0)
    #assert_that(qgrid > 0)

    Sys.setenv(OMP_NUM_THREADS = 1)
    Sys.setenv(STARPU_CALIBRATE = 1)
    Sys.setenv(STARPU_SILENT = 1) 
    Sys.setenv(KMP_AFFINITY = "disabled")   
    
    .C("rexageostat_init",
       as.integer(ncores),
       as.integer(ngpus),
       as.integer(dts))
    print("ExaGeoStatR instance is active now.")
  }

#' Finalize the current instance of ExaGeoStatR
#' @return N/A
#' @examples
#' exageostat_finalize()
exageostat_finalize <- function()
{
  if(exists("active_instance") && active_instance == 1)
  {
     .C("rexageostat_finalize")
      active_instance <<- 0
     print("ExaGeoStatR instance deactiviated.")
  }
  else
     print("No active instances.")
}
