\name{BiasedUrn-package}
\alias{BiasedUrn}
\concept{noncentral hypergeometric distribution}
\concept{Wallenius' noncentral hypergeometric distribution}
\concept{Fisher's noncentral hypergeometric distribution}
\concept{extended hypergeometric distribution}
\concept{multivariate hypergeometric distribution}
\concept{biased urn model}
\concept{biased sampling}
\concept{evolution by natural selection}
\docType{package}
\title{Biased Urn Model Distributions}
\description{
Statistical models of biased sampling in the form of univariate and
multivariate noncentral hypergeometric distributions, 
including Wallenius' noncentral hypergeometric distribution and
Fisher's noncentral hypergeometric distribution 
(also called extended hypergeometric distribution).

These are distributions that you can get when taking colored balls
from an urn without replacement, with bias.  
The univariate distributions are used when there are two colors of balls.  
The multivariate distributions are used when there are more 
than two colors of balls.

The (central) univariate and multivariate hypergeometric distribution
can be obtained by setting \code{odds} = 1.

Please see \code{vignette("UrnTheory")}
for a definition of these distributions and how
to decide which distribution to use in a specific case.
}
\details{
\tabular{ll}{
Package: \tab BiasedUrn\cr
Type: \tab Package\cr
Version: \tab 1.01\cr
Date: \tab 2006-11-29\cr
License: \tab Gnu GPL\cr
}

\bold{Univariate functions in this package}
\tabular{lcc}{
  \tab Wallenius' noncentral hypergeometric \tab Fisher's noncentral hypergeometric \cr
Probability mass function \tab dWNCHypergeo \tab dFNCHypergeo \cr
Cumulative distribution function \tab pWNCHypergeo \tab pFNCHypergeo \cr
Quantile function \tab qWNCHypergeo \tab qFNCHypergeo \cr
Random variate generation function \tab rWNCHypergeo \tab rFNCHypergeo \cr
Calculate mean \tab meanWNCHypergeo \tab meanFNCHypergeo \cr
Calculate variance \tab varWNCHypergeo \tab varFNCHypergeo \cr
Calculate mode \tab modeWNCHypergeo \tab modeFNCHypergeo \cr  
Estimate odds from mean \tab oddsWNCHypergeo \tab oddsFNCHypergeo \cr
Estimate number from mean and odds \tab numWNCHypergeo \tab numFNCHypergeo \cr
Minimum x \tab minHypergeo \tab minHypergeo \cr
Maximum x \tab maxHypergeo \tab maxHypergeo
}

\bold{Multivariate functions in this package}
\tabular{lcc}{
  \tab Wallenius' noncentral hypergeometric \tab Fisher's noncentral hypergeometric \cr
Probability mass function \tab dMWNCHypergeo \tab dMFNCHypergeo \cr
Random variate generation function \tab rMWNCHypergeo \tab rMFNCHypergeo \cr
Calculate mean \tab meanMWNCHypergeo \tab meanMFNCHypergeo \cr
Calculate variance \tab varMWNCHypergeo \tab varMFNCHypergeo \cr
Calculate mean and variance \tab momentsMWNCHypergeo \tab momentsMFNCHypergeo \cr
Estimate odds from mean \tab oddsMWNCHypergeo \tab oddsMFNCHypergeo \cr
Estimage number from mean and odds \tab numMWNCHypergeo \tab numMFNCHypergeo \cr
Minimum x \tab minMHypergeo \tab minMHypergeo \cr
Maximum x \tab maxMHypergeo \tab maxMHypergeo
}

}
\author{
Agner Fog

Maintainer: Agner Fog <agner@agner.org>
}

\references{
\url{http://www.agner.org/random/}
}

\keyword{ package }
\keyword{ distribution }
\keyword{ univar }
\keyword{ multivariate }

\seealso{
\code{vignette("UrnTheory")}
\cr
\code{\link{dhyper}}
\cr
\code{\link{fisher.test}}
}
\examples{
dWNCHypergeo(12, 25, 32, 20, 2.5)
}
