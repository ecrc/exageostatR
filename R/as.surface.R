#
#
# Copyright (c) 2017-2023 King Abdullah University of Science and Technology
# All rights reserved.
#
# ExaGeoStat-R is a software package provided by KAUST
#
#
#
# @file as.surface.R
# ExaGeoStat R wrapper functions
#
# @version 1.2.0
#
# @author Kesen Wang
# @date 2020-12-06
"as.surface" <- function(obj, z, location=NULL, order.variables = "xy") {
	if (is.list(obj)) {
		grid.list <- obj
	}
	if (is.matrix(obj)) {
		grid.list <- attr(obj, "grid.list")
	}

	hold <- parse.grid.list(grid.list, order.variables = "xy")

	if( !is.null(location)){

		temp<- rep( NA,  hold$ny*hold$nx)
		temp[location]<- z
		temp<- matrix( temp, ncol = hold$ny, nrow = hold$nx)
	}
	else{
		temp<- matrix( z,    ncol = hold$ny, nrow = hold$nx)
	}

	c(hold, list(z = temp) )
}
