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

#' Maximum Likelihood Evaluation  using exact method
#' @param data A list of x vector (x-dim), y vector (y-dim), and z observation vector
#' @param dmetric  A string -  distance metric - "euclidean" or "great_circle"
#' @param optimization  A list of opt lb values (clb), opt ub values (cub), tol, max_iters
#' @return vector of three values (theta1, theta2, theta3)
#' @examples
#' seed <- 0 ## Initial seed to generate XY locs.
#' sigma_sq <- 1 ## Initial variance.
#' beta <- 0.1 ## Initial range.
#' nu <- 0.5 ## Initial smoothness.
#' dmetric <- "euclidean" ## "euclidean" or "great_circle" distance.
#' n <- 144 ## The number of locations (n must be a square number, n=m^2).
#' exageostat_init(hardware = list(ncores = 2, ngpus = 0, ts = 32, pgrid = 1, qgrid = 1)) ## Initiate exageostat instance
#' data <- simulate_data_exact(sigma_sq, beta, nu, dmetric, n, seed) ## Generate Z observation vector
#' ## Estimate MLE parameters (Exact)
#' result <- exact_mle(data, dmetric, optimization = list(clb = c(0.001, 0.001, 0.001), cub = c(5, 5, 5), tol = 1e-4, max_iters = 1))
#' print(result)
#' exageostat_finalize() ## Finalize exageostat instance
exact_mle <-
  function(data = list(x, y, z),
           dmetric = c("euclidean", "great_circle"),
           optimization = list(
             clb = c(0.001, 0.001, 0.001),
             cub = c(5, 5, 5),
             tol = 1e-4,
             max_iters = 100
           )) {
    dmetric <- arg_check_mle(data, dmetric, optimization)
    n <- length(data$x)
    dmetric <- as.integer(dmetric)
    n <- as.integer(n)
    optimization$max_iters <- as.integer(optimization$max_iters)
    theta_out2 <- .C("mle_exact", data$x, n, data$y, n, data$z, n, optimization$clb, 3,
      optimization$cub, 3, dmetric, n, optimization$tol, optimization$max_iters, ncores,
      ngpus, dts, pgrid, qgrid,
      theta_out = double(6)
    )$theta_out

    newList <-
      list(
        "sigma_sq" = theta_out2[1],
        "beta" = theta_out2[2],
        "nu" = theta_out2[3],
        "time_per_iter" = theta_out2[4],
        "total_time" = theta_out2[5],
        "no_iters" = theta_out2[6]
      )
    print("MLE function (done). Hit key....")
    return(newList)
  }
