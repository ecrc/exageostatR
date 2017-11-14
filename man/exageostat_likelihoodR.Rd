\name{exageostat_likelihoodR}
\alias{exageostat_likelihoodR}
\title{ Sets up the call to the rexageostat_likelihood() C language function accessed via the  R '.C' external function call API }
\description{
  \code{exageostat_likelihoodR} demonstrates the R / C language interface
}

\usage{
exageostat_likelihoodR(n,
		ncores,
		gpus,
		ts,
		p_grid,
		q_grid,
		x,
		y,
		z,
		clb,
		cub,
		computation,
		dmetric)
}

\arguments{
  \item{ n	 }{ Integer - number of locations in the incoming data (real mode) or generated data (test mode) }
  \item{ ncores  }{ Integer - CPU threads }
  \item{ gpus    }{ Integer - GPU threads }
  \item{ ts      }{ Integer - tile size }
  \item{ p_grid  }{ Integer - (p,q) 2-D block-cyclic distribution grid }
  \item{ q_grid  }{ Integer - (p,q) 2-D block-cyclic distribution grid }
  \item{ x       }{ Double vector - x locations}
  \item{ y       }{ Double vector - y locations }
  \item{ z       }{ Double vector - z observations at (x, y) }
  \item{ clb     }{ Double vector - optimizer lower bounds theta values }
  \item{ cub     }{ Double vector - optimizer upper bounds theta values }
  \item{ computation }{ String - "exact" or "approx" }
  \item{ dmetric     }{ String - "dm" or "gcd" }
}

\value{
   Returned value: vector of three values (theta1, theta2, theta3)
  \item{ theta_out   }{ Double vector - theta_out }
}
\author{ Sameh Abdulah, Postdoctoral Fellow, Extreme Computing and Research Center, KAUST \email{sameh.abdulah@kaust.edu.sa}}

\examples{
#
# inline call at R command line or in another R function:
# Provides function arguments for and calls the R exageostat__gen_zR() function.
#
#exageostat_likelihood(n,
#               ncores,
#               gpus,
#               ts,
#               p_grid,
#		q_grid,
#		theta,
#		computation,
#		dmetric)
}


\keyword{programming}
