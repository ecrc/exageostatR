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
# @date 2020-09-02

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

#' Simulate Geospatial data (x, y, z)
#' @param sigma_sq A number - variance parameter
#' @param beta A number - range parameter)
#' @param nu A number  - smoothness parameter
#' @param dmetric  A string -  distance metric - "euclidean" or "great_circle"
#' @param n  A number -  data size
#' @param seed  A number -  seed of random generation
#' @return a list of of three vectors (x, y, z)
#' @examples
#' seed <- 0 ## Initial seed to generate XY locs.
#' sigma_sq <- 1 ## Initial variance.
#' beta <- 0.1 ## Initial range.
#' nu <- 0.5 ## Initial smoothness.
#' dmetric <- "euclidean" ## "euclidean" or "great_circle" distance.
#' n <- 1600 ## The number of locations (n must be a square number, n=m^2).
#' exageostat_init(hardware = list(ncores = 2, ngpus = 0, ts = 320, pgrid = 1, qgrid = 1)) ## Initiate exageostat instance
#' data <- simulate_data_exact(sigma_sq, beta, nu, dmetric, n, seed) ## Generate Z observation vector
#' data
#' exageostat_finalize() ## Finalize exageostat instance
simulate_data_exact <-
  function(sigma_sq,
           beta,
           nu,
           dmetric = c("euclidean", "great_circle"),
           n,
           seed = 0) {
    dmetric <- arg_check_sim(sigma_sq, beta, nu, dmetric)
    assert_that(length(n) == 1)
    assert_that(n >= 1)
    assert_that(length(seed) == 1)
    dmetric <- as.integer(dmetric)
    n <- as.integer(n)
    seed <- as.integer(seed)
    globalveclen <- as.integer(3 * n)
    globalvec2 <- .C("gen_z_exact", sigma_sq, beta, nu, dmetric, n, seed, ncores, ngpus,
      dts, pgrid, qgrid, globalveclen,
      globalvec = double(globalveclen)
    )$globalvec
    newList <-
      list(
        "x" = globalvec2[1:n],
        "y" = globalvec2[(n + 1):(2 * n)],
        "z" = globalvec2[((2 * n) + 1):(3 * n)]
      )

    print("back from gen_z_exact  C function call. Hit key....")
    return(newList)
  }
