#
#
# Copyright (c) 2017-2023 King Abdullah University of Science and Technology
# All rights reserved.
#
# ExaGeoStat-R is a software package provided by KAUST
#
#
#
# @file simulate_data.R
# ExaGeoStat R wrapper functions
#
# @version 1.2.0
#
# @author Sameh Abdulah
# @date 2021-10-27

library(assertthat)

#' Simulate Geospatial data (x, y, z)
#' @param kernel: string - kernel  ("ugsm-s", "ugsmn-s",  "bgsfm-s", "bgspm-s", "tgspm-s", "ugsm-st", "bgsm-st")
#' @param theta:  list of n parameters (estimated theta)
#' @param dmetric  A string -  distance metric - "euclidean" or "great_circle"
#' @param n  A number -  data size
#' @param seed  A number -  seed of random generation
#' @return a list of of three vectors (x, y, z)
#' @examples
#' seed <- 0 ## Initial seed to generate XY locs.
#' kernel <- "ugsm-s"
#' theta <- c(1, 0.1, 0.5)                                     #Params vector.
#' dmetric <- "euclidean" ## "euclidean" or "great_circle" distance.
#' n <- 1600 ## The number of locations (n must be a square number, n=m^2).
#' exageostat_init(hardware = list(ncores = 2, ngpus = 0, ts = 320, lts = 0, pgrid = 1, qgrid = 1)) ## Initiate exageostat instance
#' data <- simulate_data_exact(kernel, theta, dmetric, n, seed) ## Generate Z observation vector
#' data
#' exageostat_finalize() ## Finalize exageostat instance
simulate_data_exact <-
    function(kernel = c("ugsm-s", "ugsmn-s",  "bgsfm-s", "bgspm-s", "tgspm-s", "ugsm-st", "bgsm-st"),
             theta, dmetric = c("euclidean", "great_circle"),
             n, seed = 0) {

        if (!exists("active_instance") || active_instance == 0) {
            print("No active ExaGeoStatR instance.")
        }
        else {
            #check args
            kernel <-  check_kernel(kernel);
            dmetric <- check_dmetric(dmetric);
            check_theta (theta);

            #Check the number of locations (n)
            assert_that(length(n) == 1) #why diff the data_xy
            assert_that(n >= 1)

            thetalen <- length(theta)
            #Check the seed length
            assert_that(length(seed) == 1)

            globalveclen <- 3 * n
            globalvec <- vector(mode = "double", length = globalveclen)

            globalvec2 <- .C(
                             "gen_z_exact",
                             as.integer(kernel),
                             as.double(theta),
                             as.integer(thetalen),
                             as.integer(dmetric),
                             as.integer(n),
                             as.integer(seed),
                             as.integer(ncores),
                             as.integer(ngpus),
                             as.integer(dts),
                             as.integer(pgrid),
                             as.integer(qgrid),
                             as.integer(globalveclen),
                             globalvec = double(globalveclen)
                             )$globalvec
            newList <-
                list(
                     "x" = globalvec2[1:n], # why diff
                     "y" = globalvec2[(n + 1):(2 * n)],
                     "z" = globalvec2[((2 * n) + 1):(3 * n)]
                     )
            print("Synthetic data have been generated.")
            return(newList)
        }
    }
