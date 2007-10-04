# ApproxHypergeo.R
# This demo compares a Wallenius' and a Fisher's noncentral hypergeometric 
# distribution with the same mean rather than the same odds in order to
# make them approximate each other better.

require(BiasedUrn)
require(stats)

plot3 <- function(m1, m2, n) {
  xmin <- minHypergeo(m1, m2, n)
  xmax <- maxHypergeo(m1, m2, n)
  x <- xmin : xmax
  wnc  <- dWNCHypergeo(x, m1, m2, n, 0.1)
  plot   (x, wnc, type="o", col="blue", pch=20,
     main = "Wallenius' Noncentral Hypergeometric distribution",
     xlab = "x", ylab = "Probability")

  wnc  <- dWNCHypergeo(x, m1, m2, n, 0.2)
  points (x, wnc, type="o", col="blue", pch=20)
  wnc  <- dWNCHypergeo(x, m1, m2, n, 0.5)
  points (x, wnc, type="o", col="blue", pch=20)
  wnc  <- dWNCHypergeo(x, m1, m2, n, 1.0)
  points (x, wnc, type="o", col="blue", pch=20)
  wnc  <- dWNCHypergeo(x, m1, m2, n, 2.0)
  points (x, wnc, type="o", col="blue", pch=20)
  wnc  <- dWNCHypergeo(x, m1, m2, n, 5.0)
  points (x, wnc, type="o", col="blue", pch=20)
  wnc  <- dWNCHypergeo(x, m1, m2, n, 10.0)
  points (x, wnc, type="o", col="blue", pch=20)
  wnc  <- dWNCHypergeo(x, m1, m2, n, 20.0)
  points (x, wnc, type="o", col="blue", pch=20)

  text(41.8, .8, "0.1", cex=1)
  text(43, .3, "0.2", cex=1)
  text(49, .22, "0.5", cex=1)
  text(57.3, .20, "1.", cex=1)
  text(65.9, .21, "2.", cex=1)
  text(74, .23, "5.", cex=1)
  text(77, .3, "10.", cex=1)
  text(78.3, .8, "20.", cex=1)
}

plot3 (80, 60, 100)