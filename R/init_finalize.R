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

.pkgenv <- new.env()

#' Initial an instance of ExaGeoStatR
#' @param hardware A list of ncores, ngpus, tile size, pgrid, and qgrid
#' @return N/A
#' @examples
#' exageostat_init(hardware = list(ncores = 2, ngpus = 0, ts = 320, lts = 0, pgrid = 1, qgrid = 1))
#' exageostat_init(hardware = list(ncores = 1, ngpus = 2, ts = 320, lts = 0, pgrid = 1, qgrid = 1))
#' exageostat_init(hardware = list(ncores = 26, ngpus = 0, ts = 320, lts = 0, pgrid = 3, qgrid = 4))
exageostat_init <-
  function(hardware = list(ncores = 2, ngpus = 0, ts = 320, lts = 0, pgrid = 1, qgrid = 1)) {
    ncores <- ifelse(is.null(hardware$ncores), 1, hardware$ncores)
    ngpus <- ifelse(is.null(hardware$ngpus), 0, hardware$ngpus)
    dts <- ifelse(is.null(hardware$ts), 320, hardware$ts)
    lts <- ifelse(is.null(hardware$lts), 0, hardware$lts)
    pgrid <- ifelse(is.null(hardware$pgrid), 1, hardware$pgrid)
    qgrid <- ifelse(is.null(hardware$qgrid), 1, hardware$qgrid)

    .pkgenv$ncores <- as.integer(ncores)
    .pkgenv$ngpus <- as.integer(ngpus)
    .pkgenv$dts <- as.integer(dts)
    .pkgenv$lts <- as.integer(lts)
    .pkgenv$pgrid <- as.integer(pgrid)
    .pkgenv$qgrid <- as.integer(qgrid)

    assert_that(.pkgenv$ncores >= 0)
    assert_that(.pkgenv$ngpus >= 0)
    assert_that(.pkgenv$dts > 0)
    assert_that(.pkgenv$lts >= 0)
    assert_that(.pkgenv$pgrid > 0)
    assert_that(.pkgenv$qgrid > 0)

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
