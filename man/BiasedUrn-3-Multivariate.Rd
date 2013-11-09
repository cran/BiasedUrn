\name{BiasedUrn-Multivariate}
\alias{BiasedUrn-Multivariate}
\alias{dMWNCHypergeo}
\alias{dMFNCHypergeo}
\alias{rMWNCHypergeo}
\alias{rMFNCHypergeo}
\alias{meanMWNCHypergeo}
\alias{meanMFNCHypergeo}
\alias{varMWNCHypergeo}
\alias{varMFNCHypergeo}
\alias{momentsMWNCHypergeo}
\alias{momentsMFNCHypergeo}
\alias{oddsMWNCHypergeo}
\alias{oddsMFNCHypergeo}
\alias{numMWNCHypergeo}
\alias{numMFNCHypergeo}
\alias{minMHypergeo}
\alias{maxMHypergeo}

\title{Biased urn models: Multivariate distributions}

\description{
Statistical models of biased sampling in the form of 
multivariate noncentral hypergeometric distributions, 
including Wallenius' noncentral hypergeometric distribution and
Fisher's noncentral hypergeometric distribution 
(also called extended hypergeometric distribution).

These are distributions that you can get when taking colored balls
from an urn without replacement, with bias.  
The univariate distributions are used when there are two colors of balls.
The multivariate distributions are used when there are more 
than two colors of balls.

Please see \code{vignette("UrnTheory")}
for a definition of these distributions and how
to decide which distribution to use in a specific case.
}

\usage{
dMWNCHypergeo(x, m, n, odds, precision = 1E-7)
dMFNCHypergeo(x, m, n, odds, precision = 1E-7)
rMWNCHypergeo(nran, m, n, odds, precision = 1E-7)
rMFNCHypergeo(nran, m, n, odds, precision = 1E-7)
meanMWNCHypergeo(m, n, odds, precision = 0.1)
meanMFNCHypergeo(m, n, odds, precision = 0.1)
varMWNCHypergeo(m, n, odds, precision = 0.1)
varMFNCHypergeo(m, n, odds, precision = 0.1)
momentsMWNCHypergeo(m, n, odds, precision = 0.1)
momentsMFNCHypergeo(m, n, odds, precision = 0.1)
oddsMWNCHypergeo(mu, m, n, precision = 0.1)
oddsMFNCHypergeo(mu, m, n, precision = 0.1)
numMWNCHypergeo(mu, n, N, odds, precision = 0.1)
numMFNCHypergeo(mu, n, N, odds, precision = 0.1)
minMHypergeo(m, n)
maxMHypergeo(m, n)
}

\arguments{
\item{x}{Number of balls of each color sampled.  
Vector with length = number of colors, or matrix with nrows = number of colors.}
\item{m}{Initial number of balls of each color in the urn.  
Length of vector = number of colors.}
\item{n}{Total number of balls sampled.  Scalar.}
\item{N}{Total number of balls in urn before sampling.  Scalar.}
\item{odds}{Odds or weight for each color, arbitrarily scaled.  Length of vector = number of colors.  
Gives the (central) multivariate hypergeometric distribution if all odds are equal.}
\item{nran}{Number of random variates to generate.  Scalar.}
\item{mu}{Mean x for each color. Length of vector = number of colors.}
\item{precision}{Desired precision of calculation.  Scalar.}
}
 
\details{
\bold{Allowed parameter values} \cr
\code{x}, \code{m}, \code{odds} and \code{mu} are all vectors with one 
element for each color.  These vectors must have the same length.  
\code{x} can also be a matrix with one column for each observation.  
The number of rows in this matrix must be equal to the number of colors.  
The maximum number of colors is currently set to 32.

All parameters must be non-negative.  
\code{n} cannot exceed \code{N = sum(m)}.
The odds may be arbitrarily scaled.  
The code has been tested with odds ratios in the range 
\eqn{10^{-9} \ldots 10^9}{1E-9 to 1E9} and zero.  
The code may work with odds ratios
outside this range, but errors or NAN can occur for extreme values of odds.  
A ball with odds = 0 is equivalent to no ball.  
\code{mu} must be within the possible range of \code{x}.

\bold{Calculation time} \cr
The calculation time depends on the specified precision and the number of colors.  
The calculation time can be high for rMWNCHypergeo and rMFNCHypergeo when nran
is high.  
The calculation time can be extremely high for dMFNCHypergeo when n is high and
the number of colors is high.  
The calculation time can be extremely high for the mean... var... and moments...
functions when \code{precision} < 0.1 and n is high and the
number of colors is high.
}

\value{
\code{dMWNCHypergeo} and \code{dMFNCHypergeo} return the probability mass 
function for the multivariate Wallenius' and Fisher's noncentral hypergeometric 
distribution, respectively.  
A single value is returned if \code{x} is a vector with length = number of colors.  
Multiple values are returned if \code{x} is a matrix with one column for each 
observation.  The number of rows must be equal to the number of colors.
\cr

\code{rMWNCHypergeo} and \code{rMFNCHypergeo} return random vectors with
the multivariate Wallenius' and Fisher's noncentral hypergeometric 
distribution, respectively.  
A vector is returned when \code{nran = 1}.  A matrix with one column for each
observation is returned when \code{nran > 1}.
\cr

\code{meanMWNCHypergeo} and \code{meanMFNCHypergeo} return the mean
of the multivariate Wallenius' and Fisher's noncentral hypergeometric 
distribution, respectively.  A simple and fast approximation is used when 
\code{precision} >= 0.1.  A full calculation of all 
possible x combinations is used when \code{precision} < 0.1.  
This can take extremely long time when the number of colors is high.
\cr

\code{varMWNCHypergeo} and \code{varMFNCHypergeo} return the variance
of the multivariate Wallenius' and Fisher's noncentral hypergeometric 
distribution, respectively.  A simple and fast approximation is used when 
\code{precision} >= 0.1.  A full calculation of all 
possible x combinations is used when \code{precision} < 0.1.  
This can take extremely long time when the number of colors is high.
\cr

\code{momentsMWNCHypergeo} and \code{momentsMFNCHypergeo} return a data
frame with the mean and variance of the multivariate Wallenius' and 
Fisher's noncentral hypergeometric distribution, respectively.  
Calculating the mean and variance in the same operation saves time when 
\code{precision} < 0.1.
\cr

\code{oddsMWNCHypergeo} and \code{oddsMFNCHypergeo} estimate the odds
from an observed mean for the multivariate Wallenius' and 
Fisher's noncentral hypergeometric distribution, respectively.  
A vector of odds is returned if \code{mu} is a vector.  
A matrix is returned if \code{mu} is a matrix with one row for each color.  
A simple and fast approximation is used regardless of the specified precision.  
Exact calculation is not supported.  
See \code{demo(OddsPrecision)}.
\cr

\code{numMWNCHypergeo} and \code{numMFNCHypergeo} estimate the 
number of balls of each color in the urn before sampling from
experimental mean and known odds ratios for
Wallenius' and Fisher's noncentral hypergeometric distributions.  
The returned \code{m} values are not integers.  
A vector of \code{m} is returned if \code{mu} is a vector.  
A matrix of \code{m} is returned if \code{mu} is a matrix with one row for each color.  
A simple and fast approximation is used regardless of the specified precision.  
Exact calculation is not supported.  
The precision of calculation is indicated by \code{demo(OddsPrecision)}.  
\cr

\code{minMHypergeo} and \code{maxMHypergeo} calculate the 
minimum and maximum value of \code{x} for the multivariate distributions.  
The values are valid for the multivariate Wallenius' and Fisher's noncentral 
hypergeometric distributions as well as for the multivariate (central) 
hypergeometric distribution.
} 

\seealso{
\code{vignette("UrnTheory")}
\cr
\code{\link{BiasedUrn-Univariate}}.
\cr
\code{\link{BiasedUrn}}.
}

\examples{
# get probability
dMWNCHypergeo(c(8,10,6), c(20,30,20), 24, c(1.,2.5,1.8))
}

\references{
\url{http://www.agner.org/random/}
}

\keyword{ distribution }
\keyword{ univar }
\keyword{ multivariate }
