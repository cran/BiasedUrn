# ApproxHypergeo.R
# This demo compares a Wallenius' and a Fisher's noncentral hypergeometric 
# distribution with the same mean rather than the same odds in order to
# make them approximate each other better.

require(BiasedUrn)
require(stats)

plot4 <- function(m1, m2, n) {
  xmin <- minHypergeo(m1, m2, n)
  xmax <- maxHypergeo(m1, m2, n)
  cl = "red"
  x <- xmin : xmax
  wnc  <- dFNCHypergeo(x, m1, m2, n, 0.01)
  plot   (x, wnc, type="o", col=cl, pch=20,
     main = "Fisher's Noncentral Hypergeometric distribution",
     xlab = "x", ylab = "Probability")

  wnc  <- dFNCHypergeo(x, m1, m2, n, 0.1)
  points (x, wnc, type="o", col=cl, pch=20)
  wnc  <- dFNCHypergeo(x, m1, m2, n, 0.316)
  points (x, wnc, type="o", col=cl, pch=20)
  wnc  <- dFNCHypergeo(x, m1, m2, n, 1.0)
  points (x, wnc, type="o", col=cl, pch=20)
  wnc  <- dFNCHypergeo(x, m1, m2, n, 3.16)
  points (x, wnc, type="o", col=cl, pch=20)
  wnc  <- dFNCHypergeo(x, m1, m2, n, 10.0)
  points (x, wnc, type="o", col=cl, pch=20)
  wnc  <- dFNCHypergeo(x, m1, m2, n, 100.0)
  points (x, wnc, type="o", col=cl, pch=20)
  wnc  <- dFNCHypergeo(x, m1, m2, n, 1000.0)
  points (x, wnc, type="o", col=cl, pch=20)

  text(42.5, .47, "0.01", cex=1)
  text(44.0, .25, "0.1", cex=1)
  text(49.5, .192, "0.316", cex=1)
  text(57.25, .188, "1.", cex=1)
  text(64.90, .182, "3.16", cex=1)
  text(72, .213, "10.", cex=1)
  text(76.65, .3, "100.", cex=1)
  text(77.20, .5, "1000.", cex=1)
}

plot4 (80, 60, 100)