\name{exageostat_egenz_glR}
\alias{exageostat_egenz_glR}
\title{ Sets up the call to the gen_z_givenlocs_exact() C language function accessed via the  R '.C' external function call API }
\description{
  \code{exageostat_egenz_glR} demonstrates the R / C language interface
}
\usage{
exageostat_egenzR(n,
		ncores,
		gpus,
		ts,
		p_grid,
		q_grid,
		x,
		y,
		theta1,
		theta2,
		theta3,
		dmetric,
		globalveclen)
}
\arguments{
  \item{n}{Integer - number of locations in the incoming data (real mode) or generated data (test mode) }
  \item{ncores}{Integer - CPU threads}
  \item{gpus}{Integer - GPU threads}
  \item{ts}{Integer - tile size}
  \item{p_grid}{Integer - (p,q) 2-D block-cyclic distribution grid}
  \item{q_grid}{Integer - (p,q) 2-D block-cyclic distribution grid}
  \item{ x }{ Double vector - x locations}
  \item{ y }{ Double vector - y locations }
  \item{theta1}{Double  - initial theta1 values to generate z}
  \item{theta2}{Double  - initial theta2 values to generate z}
  \item{theta3}{Double  - initial theta3 values to generate z}
  \item{dmetric}{ Integer - "0:dm" or "1:gcd"}
  \item{globalveclen}{ Integer - output vector length}
}
\value{
   Returned value: One vector represents: z_out.
  \item{ globalvec   }{ Double vector observations z at (x,y) }
}
\author{ Sameh Abdulah, Postdoctoral Fellow, Extreme Computing and Research Center, KAUST \email{sameh.abdulah@kaust.edu.sa}}

\examples{
#
# inline call at R command line or in another R function:
# Provides function arguments for and calls the R gen_z_exact_given_locs() function.
#
#exageostat_egenz_glR(n,
#               ncores,
#               gpus,
#               ts,
#               p_grid,
#		q_grid,
#		x,
#		y,
#		theta,
#		dmetric)
}
\keyword{programming}
