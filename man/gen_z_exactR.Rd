\name{exageostat_egenzR}
\alias{exageostat_egenzR}
\title{ Sets up the call to the gen_z_exact() C language function accessed via the  R '.C' external function call API }
\description{
  \code{exageostat_egenzR} demonstrates the R / C language interface
}
\usage{
exageostat_egenzR(n,
		ncores,
		gpus,
		ts,
		p_grid,
		q_grid,
		theta1,
		theta2,
		theta3,
		dmetric,
		seed,
		globalveclen)
}
\arguments{
  \item{n}{Integer - number of locations in the incoming data (real mode) or generated data (test mode) }
  \item{ncores}{Integer - CPU threads}
  \item{gpus}{Integer - GPU threads}
  \item{ts}{Integer - tile size}
  \item{p_grid}{Integer - (p,q) 2-D block-cyclic distribution grid}
  \item{q_grid}{Integer - (p,q) 2-D block-cyclic distribution grid}
  \item{theta1}{Double  - initial theta1 values to generate z}
  \item{theta2}{Double  - initial theta2 values to generate z}
  \item{theta3}{Double  - initial theta3 values to generate z}
  \item{dmetric}{ Integer - "0:dm" or "1:gcd"}
  \item{seed}{Integer - initial seed}
  \item{globalveclen}{ Integer - output vector length}
}
\value{
   Returned value: One vector represents: x_out, y_out, and z_out.
  \item{ globalvec   }{ Double vector - locations x, locations y, observations z at (x,y) }
}
\author{ Sameh Abdulah, Postdoctoral Fellow, Extreme Computing and Research Center, KAUST \email{sameh.abdulah@kaust.edu.sa}}

\examples{
#
# inline call at R command line or in another R function:
# Provides function arguments for and calls the R exageostat__gen_zR() function.
#
#exageostat_egenzR(n,
#               ncores,
#               gpus,
#               ts,
#               p_grid,
#		q_grid,
#		theta,
#		dmetric)
}
\keyword{programming}
