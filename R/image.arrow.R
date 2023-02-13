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
# @author Kesen Wang
# @date 2020-12-06

#This function plots vector fields of given locations and vectors. 

image.arrow <- function(a1, a2, u = NA, v = NA, arrow.ex = 0.05,
                        xpd = TRUE, true.angle = FALSE, arrowfun = arrows) {
    if (is.matrix(a1)) {
        x <- a1[, 1]
        y <- a1[, 2]
    }
    else {
        x <- a1
        y <- a2
    }
    if (is.matrix(a2)) {
        u <- a2[, 1]
        v <- a2[, 2]
    }
    ucord <- par()$usr
    arrow.ex <- arrow.ex * min(ucord[2] - ucord[1], ucord[4] -
                               ucord[3])
    if (true.angle) {
        pin <- par()$pin
        r1 <- (ucord[2] - ucord[1])/(pin[1])
        r2 <- (ucord[4] - ucord[3])/(pin[2])
    }
    else {
        r1 <- r2 <- 1
    }
    u <- u * r1
    v <- v * r2
    maxr <- max(sqrt(u^2 + v^2))
    u <- (arrow.ex * u)/maxr
    v <- (arrow.ex * v)/maxr
    invisible()
    old.xpd <- par()$xpd
    par(xpd = xpd)
    arrowfun(x, y, x + u, y + v)
    par(xpd = old.xpd)
}
