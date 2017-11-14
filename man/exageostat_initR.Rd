\name{exageostat_initR}
\alias{exageostat_initR}
\title{ Sets up the call to the rexageostat_init() C language function accessed via the  R '.C' external function call API }
\description{
  \code{rexageostat_init} demonstrates the R / C language interface
}

\usage{
exageostat_initR(ncores,
		gpus,
		ts)
}

\arguments{
  \item{ncores}{Integer - CPU threads}
  \item{gpus}{Integer - GPU threads}
  \item{ts}{Integer - tile size}
}

\value{
   Returned value: None

}
\author{ Sameh Abdulah, Postdoctoral Fellow, Extreme Computing and Research Center, KAUST \email{sameh.abdulah@kaust.edu.sa}}

\examples{
#
# inline call at R command line or in another R function:
# Provides function arguments for and calls the R exageostat__gen_zR() function.
#
#exageostat_init(ncores,
#               gpus,
#               ts)
}


\keyword{programming}
