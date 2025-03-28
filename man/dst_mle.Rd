% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mle_dst.R
\name{dst_mle}
\alias{dst_mle}
\title{Maximum Likelihood Evaluation (MLE) using Diagonal Super-tile (DST) method}
\usage{
dst_mle(
  data = list(x, y, z),
  kernel = c("ugsm-s", "ugsmn-s", "bgsfm-s", "bgspm-s", "tgspm-s", "ugsm-st", "bgsm-st"),
  dst_band = 2,
  dmetric = c("euclidean", "great_circle"),
  optimization = list(clb = c(0.001, 0.001, 0.001), cub = c(5, 5, 5), tol = 1e-04,
    max_iters = 100)
)
}
\arguments{
\item{data}{A list of x vector (x-dim), y vector (y-dim), and z observation vector}

\item{dst_band}{A number - Diagonal Super-Tile (DST) diagonal thick}

\item{dmetric}{A string -  distance metric - "euclidean" or "great_circle"}

\item{optimization}{A list of opt lb (clb), opt ub (cub), tol, max_iters}

\item{kernel:}{string - kernel  ("ugsm-s", "ugsmn-s",  "bgsfm-s", "bgspm-s", "tgspm-s", "ugsm-st", "bgsm-st")}
}
\value{
vector of three values (theta1, theta2, theta3)
}
\description{
Maximum Likelihood Evaluation (MLE) using Diagonal Super-tile (DST) method
}
\examples{
seed <- 0 ## Initial seed to generate XY locs.
dmetric <- "euclidean" ## "euclidean" or "great_circle" distance.
n <- 900 ## The number of locations (n must be a square number, n=m^2).
dst_band <- 3 ## Number of used Diagonal Super Tile (DST).
kernel <- "ugsm-s"
theta <- c(1, 0.1, 0.5)                                     #Params vector.
exageostat_init(hardware = list(ncores = 4, ngpus = 0, ts = 320, lts = 0, pgrid = 1, qgrid = 1)) ## Initiate exageostat instance
data <- simulate_data_exact(kernel, theta, dmetric, n, seed) ## Generate Z observation vector
## Estimate MLE parameters (TLR approximation)
result <- dst_mle(data, kernel, dst_band, dmetric, optimization = list(clb = c(0.001, 0.001, 0.001), cub = c(5, 5, 5), tol = 1e-4, max_iters = 4))
print(result)
exageostat_finalize() ## Finalize exageostat instance
}
