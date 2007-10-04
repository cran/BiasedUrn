# plot complementary wallenius distribution

require(BiasedUrn)
require(stats)

dCWNCHypergeo <- function(x,m1,m2,n,odds) {
  N = m1 + m2
  dWNCHypergeo(m1-x, m1,m2, N-n, 1/odds)
}


plot5 <- function(m1, m2, n) {
  N = m1 + m2
  n2 = N - n
  xmin <- m1 - maxHypergeo(m1, m2, n)
  xmax <- m1 - minHypergeo(m1, m2, n)
  cl = "violet"
  x <- xmin : xmax
  cwnc  <- dCWNCHypergeo(x, m1, m2, n2, 10.)
  plot   (x, cwnc, type="o", col=cl, pch=20,
     main = "Complementary Wallenius Noncentral Hypergeometric",
     xlab = "x", ylab = "Probability")
  cwnc  <- dCWNCHypergeo(x, m1, m2, n2, 0.2)
  points (x, cwnc, type="o", col=cl, pch=20)
  cwnc  <- dCWNCHypergeo(x, m1, m2, n2, 0.5)
  points (x, cwnc, type="o", col=cl, pch=20)
  cwnc  <- dCWNCHypergeo(x, m1, m2, n2, 1.0)
  points (x, cwnc, type="o", col=cl, pch=20)
  cwnc  <- dCWNCHypergeo(x, m1, m2, n2, 2.)
  points (x, cwnc, type="o", col=cl, pch=20)
  cwnc  <- dCWNCHypergeo(x, m1, m2, n2, 5.)
  points (x, cwnc, type="o", col=cl, pch=20)
  cwnc  <- dCWNCHypergeo(x, m1, m2, n2, 0.1)
  points (x, cwnc, type="o", col=cl, pch=20)
  cwnc  <- dCWNCHypergeo(x, m1, m2, n2, 0.05)
  points (x, cwnc, type="o", col=cl, pch=20)

  text(2.35, .8, "0.05", cex=1)
  text(3.0, .32, "0.1", cex=1)
  text(5.3, .24, "0.2", cex=1)
  text(14.2, .20, "0.5", cex=1)
  text(22.8, .20, "1.", cex=1)
  text(31.08, .216, "2.", cex=1)
  text(36.7, .24, "5.", cex=1)
  text(38.4, .68, "10.", cex=1)
}

plot5 (80, 60, 100)