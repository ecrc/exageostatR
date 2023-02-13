#
#
# Copyright (c) 2017-2023 King Abdullah University of Science and Technology
# All rights reserved.
#
# ExaGeoStat-R is a software package provided by KAUST
#
#
# @file fisher_info.R
# ExaGeoStat R wrapper functions
#
# @version 1.2.0
#
# @author Sameh Abdulah
# @date 2021-12-23

library(assertthat)

#' Compute the Fisher information matrix for a given data and theta vector
#' @param data: list of data vectors, x, and y
#' @param theta:  list of n parameters (estimated theta)
#' @param dmetric  string -  distance metric - "euclidean" or "great_circle"
#' @return list of fisher matrix elements
fisher_general <-
    function(data = list(x, y), theta, dmetric) {

        n <- length(data$x)
        thetalen <- length(theta)
        dmetric <- check_dmetric(dmetric)
        
        fisher_matrix2 <- .C(
                             "fisher_general",
                             as.double(data$x),
                             as.double(data$y),
                             as.integer((n)),
                             as.double(theta),
                             as.integer(thetalen),
                             as.integer(dts),
                             as.integer(dmetric),
                             as.integer(pgrid),
                             as.integer(qgrid),
                             fisher_matrix=double(9)
                             )$fisher_matrix
        newList <-
            list(fisher_matrix2[1], fisher_matrix2[2], fisher_matrix2[3],
                 fisher_matrix2[4], fisher_matrix2[5], fisher_matrix2[6],
                 fisher_matrix2[7], fisher_matrix2[8], fisher_matrix2[9])
        return(newList)
    }
