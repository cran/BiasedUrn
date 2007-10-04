# ApproxHypergeo.R
# This demo compares a Wallenius' and a Fisher's noncentral hypergeometric 
# distribution with the same mean rather than the same odds in order to
# make them approximate each other better.

require(BiasedUrn)
require(stats)

ApproxHypPlot <- function(m1, m2, n, w.odds) {
  xmin <- minHypergeo(m1, m2, n)
  xmax <- maxHypergeo(m1, m2, n)
  x <- xmin : xmax
  w.mean <- meanWNCHypergeo(m1, m2, n, w.odds)
  f.odds <- oddsFNCHypergeo(w.mean, m1, m2, n)
  wnc  <- dWNCHypergeo(x, m1, m2, n, w.odds)
  fnc  <- dFNCHypergeo(x, m1, m2, n, f.odds)
  fnc0 <- dFNCHypergeo(x, m1, m2, n, 1)
  plot   (x, fnc, type="o", col="red", pch=22,
     main = "Hypergeometric distributions compared",
     xlab = "x", ylab = "Probability")
  points (x, wnc, type="o", col="blue", pch=20)
  points (x, fnc0, type="o", col="green", pch=19)
}

ApproxHypPlot(80, 60, 100, 0.5)
