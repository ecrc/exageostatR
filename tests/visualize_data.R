#
# Copyright (c) 2017-2023, King Abdullah University of Science and Technology
# All rights reserved.
#
# ExaGeoStat-R is a software package provided by KAUST
#
#
#
# @file visualize_data.R
# ExaGeoStat R wrapper test example
#
# @version 1.2.0
#
# @author Kesen Wang
# @date 2019-01-17

#library("exageostatr")                                 # Load ExaGeoStat-R lib.
#library(fields)

#WORKDIR <- Sys.getenv("PWD")
#FILE_PATH <- paste(WORKDIR, "/../exageostatr/data/Data.rda", sep = "")

#load(file=FILE_PATH)                                  #load data

#x   = Data1Large$x
#y   = Data1Large$y
#z   = Data1Large$z
#obj = list("x" = x,"y" = y,"z" = z)

# Initiate exageostat instance
#exageostat_init(hardware = list (ncores = 2, ngpus = 0, ts = 320, pgrid = 1, qgrid = 1))

# Perspective plot
#image.surface(obj, type = "p")

# Finalize exageostat instance
#exageostat_finalize()