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

#' Simulate Geospatial data given (x, y) locations
#' @param x A vector  (x-dim)
#' @param y A vector (y-dim)
#' @param sigma_sq A number - variance parameter
#' @param beta A number - range parameter)
#' @param nu A number  - smoothness parameter
#' @param dmetric  A string -  distance metric - "euclidean" or "great_circle"
#' @return a list of of three vectors (x, y, z)
#' @examples
#' sigma_sq <- 1 ## Initial variance.
#' beta <- 0.1 ## Initial range.
#' nu <- 0.5 ## Initial smoothness.
#' dmetric <- "euclidean" ## "euclidean" or "great_circle" distance.
#' n <- 1600 ## The number of locations (n must be a square number, n=m^2)
#' x <- rnorm(n, 0, 1) # x measurements of n locations.
#' y <- rnorm(n, 0, 1) # y measurements of n locations.
#' exageostat_init(hardware = list(ncores = 2, ngpus = 0, ts = 320, pgrid = 1, qgrid = 1)) ## Initiate exageostat instance
#' data <- simulate_obs_exact(x, y, sigma_sq, beta, nu, dmetric) ## Generate Z observation vector based on given locations
#' data
#' exageostat_finalize() ## Finalize exageostat instance
simulate_obs_exact <-
  function(x, y, sigma_sq, beta, nu,
           dmetric = c("euclidean", "great_circle")) {
    dmetric <- arg_check_sim(sigma_sq, beta, nu, dmetric)
    assert_that(is.double(x))
    assert_that(is.double(y))
    assert_that(length(x) == length(y))
    n <- length(x)
    dmetric <- as.integer(dmetric)
    n <- as.integer(n)
    globalveclen <- as.integer(3 * n)
    globalvec2 <- .C("gen_z_givenlocs_exact", x, n, y, n, sigma_sq, beta, nu, dmetric,
      n, .pkgenv$ncores, .pkgenv$ngpus, .pkgenv$dts, .pkgenv$pgrid, .pkgenv$qgrid, globalveclen,
      globalvec = double(globalveclen)
    )$globalvec
    newList <- list(
      "x" = x[1:n],
      "y" = y[1:n],
      "z" = globalvec2[1:n]
    )
    print("back from gen_z_givenlocs_exact  C function call. Hit key....")
    return(newList)
  }
