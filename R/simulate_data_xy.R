#
#
# Copyright (c) 2017-2023 King Abdullah University of Science and Technology
# All rights reserved.
#
# ExaGeoStat-R is a software package provided by KAUST
#
#
#
# @file simulate_data_xy.R
# ExaGeoStat R wrapper functions
#
# @version 1.2.0
#
# @author Sameh Abdulah
# @date 2021-06-20

library(assertthat)

#' Simulate Geospatial data given (x, y) locations
#' @param x: A vector  (x-dim)
#' @param y: A vector (y-dim)
#' @param kernel: string - kernel  ("ugsm-s", "ugsmn-s",  "bgsfm-s", "bgspm-s", "tgspm-s", "ugsm-st", "bgsm-st")
#' @param theta:  list of n parameters (estimated theta)
#' @param dmetric:  A string -  distance metric - "euclidean" or "great_circle"
#' @return a list of three vectors (x, y, z)
#' @examples
#' kernel <- "ugsm-s"
#' theta <- c(1, 0.1, 0.5)                                     #Params vector.
#' dmetric <- "euclidean" ## "euclidean" or "great_circle" distance.
#' n <- 1600 ## The number of locations (n must be a square number, n=m^2)
#' x <- rnorm(n, 0, 1) # x measurements of n locations.
#' y <- rnorm(n, 0, 1) # y measurements of n locations.
#' exageostat_init(hardware = list(ncores = 2, ngpus = 0, ts = 320, lts = 0, pgrid = 1, qgrid = 1)) ## Initiate exageostat instance
#' data <- simulate_obs_exact(x, y, kernel, theta, dmetric) ## Generate Z observation vector based on given locations
#' data
#' exageostat_finalize() ## Finalize exageostat instance
simulate_obs_exact <-
    function(x, y, kernel=c("ugsm-s", "ugsmn-s",  "bgsfm-s", "bgspm-s", "tgspm-s", "ugsm-st", "bgsm-st"), theta,
             dmetric = c("euclidean", "great_circle")) {
        if (!exists("active_instance") || active_instance == 0) {
            print("No active ExaGeoStatR instance.")
        }
        else {
            #Check args
            kernel  <- check_kernel(kernel)
            dmetric <- check_dmetric(dmetric)
            check_theta(theta)

            assert_that(is.double(x))
            assert_that(is.double(y))

            assert_that(length(x) == length(y))
            n <- length(x)

            thetalen <-length(theta)
            globalveclen <- as.integer(3 * n)
            globalvec2 <- .C(
                             "gen_z_givenlocs_exact",
                             as.double(x),
                             as.integer((n)),
                             as.double(y),
                             as.integer(n),
                             as.integer(kernel),
                             as.double(theta),
                             as.integer(thetalen),
                             as.integer(dmetric),
                             as.integer(n),
                             as.integer(ncores),
                             as.integer(ngpus),
                             as.integer(dts),
                             as.integer(pgrid),
                             as.integer(qgrid),
                             as.integer(globalveclen),
                             globalvec = double(globalveclen) ##why from here down
                             )$globalvec
            newList <- list(
                            "x" = x[1:n],
                            "y" = y[1:n],
                            "z" = globalvec2[1:n]
                            )
            print("back from gen_z_givenlocs_exact  C function call. Hit key....")
            return(newList)
        }
    }
