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

#' Maximum Likelihood Evaluation (MLE) using Tile Low-Rank (TLR) method
#' @param data A list of x vector (x-dim), y vector (y-dim), and z observation vector
#' @param tlr_acc  A number - TLR accuracy level
#' @param tlr_maxrank  A string -  TLR max rank
#' @param dmetric  A string -  distance metric - "euclidean" or "great_circle"
#' @param optimization  A list of opt lb values (clb), opt ub values (cub), tol, max_iters
#' @return vector of three values (theta1, theta2, theta3)
#' @examples
#' seed <- 0 ## Initial seed to generate XY locs.
#' sigma_sq <- 1 ## Initial variance.
#' beta <- 0.03 ## Initial range.
#' nu <- 0.5 ## Initial smoothness.
#' dmetric <- "euclidean" ## "euclidean" or "great_circle" distance.
#' n <- 900 ## The number of locations (n must be a square number, n=m^2).
#' tlr_acc <- 7 ## Approximation accuracy 10^-(acc)
#' tlr_maxrank <- 150 ## Max Rank
#' exageostat_init(hardware = list(ncores = 2, ngpus = 0, ts = 320, lts = 600, pgrid = 1, qgrid = 1)) ## Initiate exageostat instance
#' data <- simulate_data_exact(sigma_sq, beta, nu, dmetric, n, seed) ## Generate Z observation vector
#' ## Estimate MLE parameters (TLR approximation)
#' result <- tlr_mle(data, tlr_acc, tlr_maxrank, dmetric, optimization = list(clb = c(0.001, 0.001, 0.001), cub = c(5, 5, 5), tol = 1e-4, max_iters = 4))
#' print(result)
#' exageostat_finalize() ## Finalize exageostat instance
tlr_mle <-
  function(data = list(x, y, z),
           tlr_acc = 9,
           tlr_maxrank = 400,
           dmetric = c("euclidean", "great_circle"),
           optimization = list(
             clb = c(0.001, 0.001, 0.001),
             cub = c(5, 5, 5),
             tol = 1e-4,
             max_iters = 100
           )) {
    dmetric <- arg_check_mle(data, dmetric, optimization)
    assert_that(length(tlr_acc) == 1)
    assert_that(length(tlr_maxrank) == 1)
    assert_that(tlr_acc > 0)
    assert_that(tlr_maxrank >= 1)
    n <- length(data$x)
    dmetric <- as.integer(dmetric)
    n <- as.integer(n)
    tlr_acc <- as.integer(tlr_acc)
    tlr_maxrank <- as.integer(tlr_maxrank)
    optimization$max_iters <- as.integer(optimization$max_iters)
    theta_out2 <- .C("mle_tlr", data$x, n, data$y, n, data$z, n, optimization$clb, 3,
      optimization$cub, 3, tlr_acc, tlr_maxrank, dmetric, n, optimization$tol,
      optimization$max_iters, ncores, ngpus, lts, pgrid, qgrid,
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
