\name{BiasedUrn-Univariate}
\alias{BiasedUrn-Univariate}
\alias{dWNCHypergeo}
\alias{dFNCHypergeo}
\alias{pWNCHypergeo}
\alias{pFNCHypergeo}
\alias{qWNCHypergeo}
\alias{qFNCHypergeo}
\alias{rWNCHypergeo}
\alias{rFNCHypergeo}
\alias{meanWNCHypergeo}
\alias{meanFNCHypergeo}
\alias{varWNCHypergeo}
\alias{varFNCHypergeo}
\alias{modeWNCHypergeo}
\alias{modeFNCHypergeo}
\alias{oddsWNCHypergeo}
\alias{oddsFNCHypergeo}
\alias{numWNCHypergeo}
\alias{numFNCHypergeo}
\alias{minHypergeo}
\alias{maxHypergeo}

\title{Biased urn models: Univariate distributions}

\description{
Statistical models of biased sampling in the form of noncentral 
hypergeometric distributions, 
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
dWNCHypergeo(x, m1, m2, n, odds, precision=1E-7)
dFNCHypergeo(x, m1, m2, n, odds, precision=1E-7)
pWNCHypergeo(x, m1, m2, n, odds, precision=1E-7, lower.tail=TRUE)
pFNCHypergeo(x, m1, m2, n, odds, precision=1E-7, lower.tail=TRUE)
qWNCHypergeo(p, m1, m2, n, odds, precision=1E-7, lower.tail=TRUE)
qFNCHypergeo(p, m1, m2, n, odds, precision=1E-7, lower.tail=TRUE)
rWNCHypergeo(nran, m1, m2, n, odds, precision=1E-7)
rFNCHypergeo(nran, m1, m2, n, odds, precision=1E-7)
meanWNCHypergeo(m1, m2, n, odds, precision=1E-7)
meanFNCHypergeo(m1, m2, n, odds, precision=1E-7)
varWNCHypergeo(m1, m2, n, odds, precision=1E-7)
varFNCHypergeo(m1, m2, n, odds, precision=1E-7)
modeWNCHypergeo(m1, m2, n, odds, precision=1E-7)
modeFNCHypergeo(m1, m2, n, odds, precision=0)
oddsWNCHypergeo(mu, m1, m2, n, precision=0.1)
oddsFNCHypergeo(mu, m1, m2, n, precision=0.1)
numWNCHypergeo(mu, n, N, odds, precision=0.1)
numFNCHypergeo(mu, n, N, odds, precision=0.1)
minHypergeo(m1, m2, n)
maxHypergeo(m1, m2, n)
}

\arguments{
\item{x}{Number of red balls sampled.}
\item{m1}{Initial number of red balls in the urn.}
\item{m2}{Initial number of white balls in the urn.}
\item{n}{Total number of balls sampled.}
\item{N}{Total number of balls in urn before sampling.}
\item{odds}{Probability ratio of red over white balls.}
\item{p}{Cumulative probability.}
\item{nran}{Number of random variates to generate.}
\item{mu}{Mean x.}
\item{precision}{Desired precision of calculation.}
\item{lower.tail}{if TRUE (default), probabilities are
 \eqn{P(X \le x)}{P(X <= x)}, otherwise, \eqn{P(X > x)}{P(X > x)}.}
 }
 
\details{
\bold{Allowed parameter values} \cr
All parameters must be non-negative.  \code{n} cannot exceed \code{N = m1 + m2}.  
The code has been tested with odds in the range 
\eqn{10^{-9} \ldots 10^9}{1E-9 to 1E9} and zero.  The code may work with odds
outside this range, but errors or NAN can occur for extreme values of odds.
A ball with odds = 0 is equivalent to no ball.  
\code{mu} must be within the possible range of \code{x}.

\bold{Calculation time} \cr
The calculation time depends on the specified precision.
}

\value{
\code{dWNCHypergeo} and \code{dFNCHypergeo} return the probability mass function for
Wallenius' and Fisher's noncentral hypergeometric distribution, respectively.  
A single value is returned if \code{x} is a scalar.  
Multiple values are returned if \code{x} is a vector.
\cr

\code{pWNCHypergeo} and \code{pFNCHypergeo} return the 
cumulative probability function for
Wallenius' and Fisher's noncentral hypergeometric distribution, respectively.  
A single value is returned if \code{x} is a scalar.  
Multiple values are returned if \code{x} is a vector.
\cr

\code{qWNCHypergeo} and \code{qFNCHypergeo} return the quantile function for
Wallenius' and Fisher's noncentral hypergeometric distribution, respectively.  
A single value is returned if \code{p} is a scalar.  
Multiple values are returned if \code{p} is a vector.
\cr

\code{rWNCHypergeo} and \code{rFNCHypergeo} return 
random variates with Wallenius' and Fisher's noncentral hypergeometric 
distribution, respectively.
\cr

\code{meanWNCHypergeo} and \code{meanFNCHypergeo} calculate the mean
of Wallenius' and Fisher's noncentral hypergeometric 
distribution, respectively.  A simple and fast approximation is used when 
\eqn{precision \geq 0.1}{precision >= 0.1}.
\cr

\code{varWNCHypergeo} and \code{varFNCHypergeo} calculate the variance
of Wallenius' and Fisher's noncentral hypergeometric 
distribution, respectively.  A simple and fast approximation is used when 
\eqn{precision \geq 0.1}{precision >= 0.1}.
\cr

\code{modeWNCHypergeo} and \code{modeFNCHypergeo} calculate the mode
of Wallenius' and Fisher's noncentral hypergeometric 
distribution, respectively.
\cr

\code{oddsWNCHypergeo} and \code{oddsFNCHypergeo} estimate the odds
of Wallenius' and Fisher's noncentral hypergeometric 
distribution from a measured mean.
A single value is returned if \code{mu} is a scalar.  
Multiple values are returned if \code{mu} is a vector.  
A simple and fast approximation is used regardless of the specified precision.  
Exact calculation is not supported.  
See \code{demo(OddsPrecision)}.
\cr

\code{numWNCHypergeo} and \code{numFNCHypergeo} estimate the 
number of balls of each color in the urn before sampling from
an experimental mean and a known odds ratio for
Wallenius' and Fisher's noncentral hypergeometric distributions.  
The returned numbers \code{m1} and \code{m2} are not integers.  
A vector of \code{m1} and \code{m2} is returned if \code{mu} is a scalar.  
A matrix is returned if \code{mu} is a vector.
A simple approximation is used regardless of the specified precision.  
Exact calculation is not supported.  
The precision of calculation is indicated by \code{demo(OddsPrecision)}.  
\cr

\code{minHypergeo} and \code{maxHypergeo} calculate the 
minimum and maximum value of \code{x}.  The value is valid for 
Wallenius' and Fisher's noncentral hypergeometric distribution
as well as for the (central) hypergeometric distribution.
} 

\seealso{
\code{vignette("UrnTheory")}
\cr
\code{\link{BiasedUrn-Multivariate}}.
\cr
\code{\link{fisher.test}}
}

\examples{
# get probability
dWNCHypergeo(12, 25, 32, 20, 2.5)
}

\references{
\url{http://www.agner.org/random/}
}

\keyword{ distribution }
\keyword{ univar }
