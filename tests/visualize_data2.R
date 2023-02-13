#
#
# Copyright (c) 2017-2023, King Abdullah University of Science and Technology
# All rights reserved.
#
# ExaGeoStat-R is a software package provided by KAUST
#
#
#
# @file exageostatR-dev.R
# ExaGeoStat R wrapper test example
#
# @version 1.2.0
#
# @author Kesen Wang
# @date 2021-12-06

# Load ExaGeoStat-R lib
library("exageostatr")                                           


#load data
WORKDIR <- Sys.getenv("PWD")
FILE_PATH <- paste(WORKDIR, "/../exageostatr/data/Data.rda", sep = "")

load(file=FILE_PATH)                                  #load data

x = rnorm(20)
y = rnorm(20)
u = rnorm(20)
v = rnorm(20)

#Initiate exageostat instance
exageostat_init(hardware = list (ncores = 2, ngpus = 0, ts = 320, pgrid = 1, qgrid = 1))

plot(x,y)

# Arrow plot
image.arrow(x,y,u,v)         

# Finalize exageostat instance
exageostat_finalize()