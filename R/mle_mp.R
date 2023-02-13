#
#
# Copyright (c) 2017-2023 King Abdullah University of Science and Technology
# All rights reserved.
#
# ExaGeoStat-R is a software package provided by KAUST
#
#
#
# @file mle_mp.R
# ExaGeoStat R wrapper functions
#
# @version 1.2.0
#
# @author Kesen Wang
# @author Sameh Abdulah
# @date 2021-12-20

#library(assertthat)

# Maximum Likelihood Evaluation (MLE) using Mixed Precision (MP) method
# @param data A list of x vector (x-dim), y vector (y-dim), and z observation vector
# @param mp_band  A number - Mixed Precision (MP) band
# @param dmetric  A string -  distance metric - "euclidean" or "great_circle"
# @param optimization  A list of opt lb (clb), opt ub (cub), tol, max_iters
# @return vector of three values (theta1, theta2, theta3)
# @examples
# seed <- 0 ## Initial seed to generate XY locs.
# sigma_sq <- 1 ## Initial variance.
# beta <- 0.03 ## Initial range.
# nu <- 0.5 ## Initial smoothness.
# dmetric <- "euclidean" ## "euclidean" or "great_circle" distance.
# n <- 900 ## The number of locations (n must be a square number, n=m^2).
# mp_band <- 3 ## Number of used Mixed Precision (MP).
# exageostat_init(hardware = list(ncores = 4, ngpus = 0, ts = 320, pgrid = 1, qgrid = 1)) ## Initiate exageostat instance
# data <- simulate_data_exact(sigma_sq, beta, nu, dmetric, n, seed) ## Generate Z observation vector
# ## Estimate MLE parameters (TLR approximation)
# result <- dst_mle(data, mp_band, dmetric, optimization = list(clb = c(0.001, 0.001, 0.001), cub = c(5, 5, 5), tol = 1e-4, max_iters = 4))
# print(result)
# exageostat_finalize() ## Finalize exageostat instance

#mp_mle <-
#    function(data = list(x, y, z),
#             kernel=c("ugsm-s", "ugsmn-s",  "bgsfm-s", "bgspm-s", "tgspm-s", "ugsm-st", "bgsm-st"),
#             mp_band = 2,
#             dmetric = c("euclidean", "great_circle"),
#             optimization = list(
#                                 clb = c(0.001, 0.001, 0.001),
#                                 cub = c(5, 5, 5),
#                                 tol = 1e-4,
#                                 max_iters = 100
#                                 )) {
#        if (!exists("active_instance") || active_instance == 0) {
#            print("No active ExaGeoStatR instance.")
#        }
#        else {
#            kernel  <- check_kernel(kernel)
#            dmetric <- arg_check_mle(data, dmetric, optimization)
#
#            assert_that(length(mp_band) == 1)
#            assert_that(mp_band >= 1)
#            n <- length(data$x)
#            n <- as.integer(n)
#            optimization$max_iters <- as.integer(optimization$max_iters)
#            theta_out2 <- .C(
#                             "mle_mp",
#                             as.double(data$x),
#                             as.integer((n)),
#                             as.double(data$y),
#                             as.integer((n)),
#                             as.double(data$z),
#                             as.integer((n)),
#                             as.integer(kernel),
#                             as.double(optimization$clb),
#                             as.integer((3)),
#                             as.double(optimization$cub),
#                             as.integer((3)),
#                             as.integer(mp_band),
#                             as.integer(dmetric),
#                             as.integer(n),
#                             as.double(optimization$tol),
#                             as.integer(optimization$max_iters),
#                             as.integer(ncores),
#                             as.integer(ngpus),
#                             as.integer(dts),
#                             as.integer(pgrid),
#                             as.integer(qgrid),
#                             theta_out = double(6)
#                             )$theta_out
#
#            newList <-
#                list(
#                     "sigma_sq" = theta_out2[1],
#                     "beta" = theta_out2[2],
#                     "nu" = theta_out2[3],
#                     "time_per_iter" = theta_out2[4],
#                     "total_time" = theta_out2[5],
#                     "no_iters" = theta_out2[6]
#                     )
#            print("MLE_MP function (done). Hit key....")
#            return(newList)
#        }
#    }