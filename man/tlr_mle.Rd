% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mle_tlr.R
\name{tlr_mle}
\alias{tlr_mle}
\title{Maximum Likelihood Evaluation (MLE) using Tile Low-Rank (TLR) method}
\usage{
tlr_mle(
  data = list(x, y, z),
  kernel = c("ugsm-s", "ugsmn-s", "bgsfm-s", "bgspm-s", "tgspm-s", "ugsm-st", "bgsm-st"),
  tlr_acc = 9,
  tlr_maxrank = 400,
  dmetric = c("euclidean", "great_circle"),
  optimization = list(clb = c(0.001, 0.001, 0.001), cub = c(5, 5, 5), tol = 1e-04,
    max_iters = 100)
)
}
\arguments{
\item{data}{A list of x vector (x-dim), y vector (y-dim), and z observation vector}

\item{tlr_acc}{A number - TLR accuracy level}

\item{tlr_maxrank}{A string -  TLR max rank}

\item{dmetric}{A string -  distance metric - "euclidean" or "great_circle"}

\item{optimization}{A list of opt lb values (clb), opt ub values (cub), tol, max_iters}

\item{kernel:}{string - kernel  ("ugsm-s", "ugsmn-s",  "bgsfm-s", "bgspm-s", "tgspm-s", "ugsm-st", "bgsm-st")}
}
\value{
vector of three values (theta1, theta2, theta3)
}
\description{
Maximum Likelihood Evaluation (MLE) using Tile Low-Rank (TLR) method
}
\examples{
seed <- 0 ## Initial seed to generate XY locs.
kernel <- "ugsm-s"
theta <- c(1, 0.1, 0.5)                                     #Params vector.
dmetric <- "euclidean" ## "euclidean" or "great_circle" distance.
n <- 900 ## The number of locations (n must be a square number, n=m^2).
tlr_acc <- 7 ## Approximation accuracy 10^-(acc)
tlr_maxrank <- 150 ## Max Rank
exageostat_init(hardware = list(ncores = 2, ngpus = 0, ts = 320, lts = 1000, pgrid = 1, qgrid = 1)) ## Initiate exageostat instance
data <- simulate_data_exact(kernel, theta, dmetric, n, seed) ## Generate Z observation vector
## Estimate MLE parameters (TLR approximation)
result <- tlr_mle(data, kernel, tlr_acc, tlr_maxrank, dmetric, optimization = list(clb = c(0.001, 0.001, 0.001), cub = c(5, 5, 5), tol = 1e-4, max_iters = 4))
print(result)
exageostat_finalize() ## Finalize exageostat instance
}
