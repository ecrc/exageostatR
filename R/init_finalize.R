#
#
# Copyright (c) 2017, 2018, 2019 King Abdullah University of Science and Technology
# All rights reserved.
#
# ExaGeoStat-R is a software package provided by KAUST
#
#
#
# @file exageostat_test_wrapper.R
# ExaGeoStat R wrapper functions
#
# @version 0.1.0
#
# @author Sameh Abdulah
# @date 2019-09-25

library(assertthat)

utils::globalVariables(c("ncores"))
utils::globalVariables(c("ngpus"))
utils::globalVariables(c("dts"))
utils::globalVariables(c("lts"))
utils::globalVariables(c("pgrid"))
utils::globalVariables(c("qgrid"))
utils::globalVariables(c("x"))
utils::globalVariables(c("y"))
utils::globalVariables(c("z"))

#' Initial an instance of ExaGeoStatR
#' @param hardware A list of ncores, ngpus, tile size, pgrid, and qgrid
#' @return N/A
#' @examples
#' exageostat_init(hardware = list(ncores = 2, ngpus = 0, ts = 320, lts = 0, pgrid = 1, qgrid = 1))
#' exageostat_init(hardware = list(ncores = 1, ngpus = 2, ts = 320, lts = 0, pgrid = 1, qgrid = 1))
#' exageostat_init(hardware = list(ncores = 26, ngpus = 0, ts = 320, lts = 0, pgrid = 3, qgrid = 4))
exageostat_init <-
  function(hardware = list(ncores = 2, ngpus = 0, ts = 320, lts = 0, pgrid = 1, qgrid = 1)) {
    ncores <- hardware$ncores
    ngpus <- hardware$ngpus
    dts <- hardware$ts
    lts <- hardware$lts
    pgrid <- hardware$pgrid
    qgrid <- hardware$qgrid

    ncores <- as.integer(ncores)
    ngpus <- as.integer(ngpus)
    dts <- as.integer(dts)
    lts <- as.integer(lts)
    pgrid <- as.integer(pgrid)
    qgrid <- as.integer(qgrid)

    assert_that(ncores >= 0)
    assert_that(ngpus >= 0)
    assert_that(dts > 0)
    assert_that(lts >= 0)
    assert_that(pgrid > 0)
    assert_that(qgrid > 0)

    Sys.setenv(OMP_NUM_THREADS = 1)
    Sys.setenv(STARPU_CALIBRATE = 1)
    Sys.setenv(STARPU_SILENT = 1)
    Sys.setenv(KMP_AFFINITY = "disabled")
    .C("rexageostat_init", ncores, ngpus, dts)
    print("back from exageostat_init C function call. Hit key....")
  }

#' Finalize the current instance of ExaGeoStatR
#' @return N/A
#' @examples
#' exageostat_finalize()
exageostat_finalize <- function() {
  .C("rexageostat_finalize")
  print("back from exageostat_finalize C function call. Hit key....")
}
