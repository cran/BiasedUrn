# CompareHypergeo.R
# This demo shows the difference between the three distributions:
# 1. Wallenius' noncentral hypergeometric distribution
# 2. Fisher's noncentral hypergeometric distribution
# 3. The (central) hypergeometric distribution

require(BiasedUrn)
require(stats)

ComparePlot <- function(m1, m2, n, odds) {
  xmin <- minHypergeo(m1, m2, n)
  xmax <- maxHypergeo(m1, m2, n)
  x <- xmin : xmax
  wnc <- dWNCHypergeo(x, m1, m2, n, odds)
  fnc <- dFNCHypergeo(x, m1, m2, n, odds)
  hyp <- dhyper(x, m1, m2, n)
  plot   (x, wnc, type="o", col="blue", pch=19,
     main = "Hypergeometric distributions compared", 
     ylab = "Probability", xlab="x")
  points (x, fnc, type="o", col="red", pch=19)
  points (x, hyp, type="o", col="green", pch=19)
}

ComparePlot(80, 60, 100, 0.5)
