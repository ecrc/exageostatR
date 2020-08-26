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

#' Maximum Likelihood Evaluation (MLE) using Diagonal Super-tile (DST) method
#' @param data A list of x vector (x-dim), y vector (y-dim), and z observation vector
#' @param dst_thick  A number - Diagonal Super-Tile (DST) diagonal thick
#' @param dmetric  A string -  distance metric - "euclidean" or "great_circle"
#' @param optimization  A list of opt lb (clb), opt ub (cub), tol, max_iters
#' @return vector of three values (theta1, theta2, theta3)
#' @examples
#' seed <- 0 ## Initial seed to generate XY locs.
#' sigma_sq <- 1 ## Initial variance.
#' beta <- 0.03 ## Initial smoothness.
#' nu <- 0.5 ## Initial range.
#' dmetric <- "euclidean" ## "euclidean" or "great_circle" distance.
#' n <- 900 ## The number of locations (n must be a square number, n=m^2).
#' dst_thick <- 3 ## Number of used Diagonal Super Tile (DST).
#' exageostat_init(hardware = list(ncores = 4, ngpus = 0, ts = 320, pgrid = 1, qgrid = 1)) ## Initiate exageostat instance
#' data <- simulate_data_exact(sigma_sq, beta, nu, dmetric, n, seed) ## Generate Z observation vector
#' ## Estimate MLE parameters (TLR approximation)
#' result <- dst_mle(data, dst_thick, dmetric, optimization = list(clb = c(0.001, 0.001, 0.001), cub = c(5, 5, 5), tol = 1e-4, max_iters = 4))
#' print(result)
#' exageostat_finalize() ## Finalize exageostat instance
dst_mle <-
  function(data = list(x, y, z),
           dst_thick,
           dmetric = c("euclidean", "great_circle"),
           optimization = list(
             clb = c(0.001, 0.001, 0.001),
             cub = c(5, 5, 5),
             tol = 1e-4,
             max_iters = 100
           )) {
    dmetric <- arg_check_mle(data, dmetric, optimization)
    assert_that(length(dst_thick) == 1)
    assert_that(dst_thick >= 1)
    n <- length(data$x)
    dmetric <- as.integer(dmetric)
    n <- as.integer(n)
    dst_thick <- as.integer(dst_thick)
    optimization$max_iters <- as.integer(optimization$max_iters)
    theta_out2 <- .C("mle_dst", data$x, n, data$y, n, data$z, n, optimization$clb, 3,
      optimization$cub, 3, dst_thick, dmetric, n, optimization$tol, optimization$max_iters,
      ncores, ngpus, dts, pgrid, qgrid,
      theta_out = double(6)
    )$theta_out
    print("back from mle_exact C function call. Hit key....")
    newList <-
      list(
        "sigma_sq" = theta_out2[1],
        "beta" = theta_out2[2],
        "nu" = theta_out2[3],
        "time_per_iter" = theta_out2[4],
        "total_time" = theta_out2[5],
        "no_iters" = theta_out2[6]
      )
    return(newList)
  }
